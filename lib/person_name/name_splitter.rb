module PersonName
  class NameSplitter

    NAME_PARTS = %w(prefix first_name middle_name intercalation last_name suffix)

    def self.split(new_name_str, existing_values = {})
      parts = new_name_str.split " "
      names = []
      stage = :prefix
      remember = nil
      parts.each_with_index do |part, index|
        is_upcase = (part[0,1] == part[0,1].upcase)
        has_dash = part.include? "-"
        is_last = (parts.length - 1) == index

        fp = [remember, part].compact.join(" ")
        remember = nil
        did_remember = (fp != part)
        if valid_prefix?(part) and stage == :prefix # if the part is a valid prefix, mark it as such
          names = add_to_last_if :prefix, fp, names
        elsif valid_suffix?(part) and stage == :name # if the part is a valid suffix, mark it as such
          names = add_to_last_if :suffix, fp, names
        elsif part == "-" # if the part is a dash
          if last_stored = names.pop # retrieve the previous name part (if any) and store it with the dash
            # for the part to come (remember)
            remember = [last_stored[0], fp].compact.join(" ")
          else
            # if there is no previous part, just store the current part for later
            remember = fp
          end
        elsif !is_upcase and !did_remember # intercalation words are never with a capital
          names = add_to_last_if :intercalation, fp, names
          stage = :name
        elsif !is_upcase and did_remember
          remember = fp
        elsif is_upcase and !has_dash
          names << [fp, :name]
          stage = :name
        elsif is_upcase and has_dash
          if fp.ends_with? "-"
            if is_last
              names << [fp, :name]
              stage = :name
            else
              remember = fp
            end
          else
            if fp.starts_with?("-") and last_stored = names.pop
              fp = [last_stored[0], fp].compact.join(" ")
            end
            dash_parts = fp.split "-"
            if dash_parts.last.first == dash_parts.last.first.upcase
              names << [fp, :name]
              stage = :name
            elsif is_last
              names << [fp, :name]
              stage = :name
            else
              remember = fp
            end
          end
        end
      end

      new_name = {}
      stage = O[:prefix]

      names.each_with_index do |value, index|
        name, name_type = *value
        stage = recheck_stage(name, stage, existing_values)

        if name_type == :prefix and stage == O[:prefix]
        elsif name_type == :suffix and (index == names.length - 1)
          stage = [O[:suffix], stage].max
        elsif name_type == :suffix and (index != names.length - 1)
          name_type = :name
        end

        if name_type == :name
          if (index == names.length - 1) or new_name[:intercalation]
            stage = [O[:last_name], stage].max
          else
            if !new_name[:first_name]
              stage = [O[:first_name], stage].max
            else
              stage = [O[:middle_name], stage].max
            end
          end
        elsif name_type == :intercalation
          stage = [O[:intercalation], stage].max
        end
        new_name = add_part(new_name, stage, name)
      end
      new_name
    end

    private

    O = {
            :prefix => 0,
            :first_name => 1,
            :middle_name => 2,
            :intercalation => 3,
            :last_name => 4,
            :suffix => 5
    }.freeze
    OR = O.invert

    def self.add_part new_name, part_score, part
      part_name = OR[part_score]
      new_name[part_name.to_sym] = [new_name[part_name.to_sym], part].compact.join(" ")
      new_name
    end

    def self.recheck_stage value, stage, old_values
      # test if the given value is already stored in the name right now
      new_stage = stage
      NAME_PARTS.each do |part|
        part_values = (old_values[part.to_sym] || "").split(" ")

        part_score = O[part.to_sym]
        if part_values.include? value
          part_score = O[:first_name] if stage == O[:prefix] and part = :middle_name
          new_stage = part_score if part_score > new_stage
          return new_stage
        end
      end
      stage
    end

    def self.add_to_last_if part, value, list
      if list.last and list.last[1] == part
        last_part = list.pop
        list << [[last_part[0], value].compact.join(" "), part]
      else
        list << [value, part]
      end
      list
    end

    def self.valid_prefix? name_part
      false
    end

    def self.valid_suffix? name_part
      false
    end

  end
end