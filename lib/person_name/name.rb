module PersonName
  class ActiveRecordPersonName

    def initialize(naming_prefix, record)
      @naming_prefix = naming_prefix
      @record = record
    end

    def full_name
      NameSplitter::NAME_PARTS.collect { |p| self.send(p) }.compact.join " "
    end

    def full_name= new_name
      return if full_name == new_name # no changes
      old_values = {}
      NameSplitter::NAME_PARTS.collect { |p| old_values[p.to_sym] = self.send(p) }
      new_name = NameSplitter.split(new_name, old_values)

      # assignments
      NameSplitter::NAME_PARTS.each do |part|
        self.send "#{part}=", (new_name[part.to_sym] || "").blank? ? nil : new_name[part.to_sym]
      end
    end

    def full_last_name
      [:intercalation, :last_name, :suffix].collect { |p| self.send(p) }.compact.join " "
    end

    def short_name include_middle_names = true
      parts = []
      parts << "#{self.first_name.first.upcase}." if self.first_name
      if include_middle_names and self.middle_name
        names = self.middle_name.split(" ")
        names.each do |name|
          parts << "#{name.first.upcase}."
        end
      end
      [parts.join, full_last_name] * " "
    end

    NameSplitter::NAME_PARTS.each do |part|
      define_method part do
        @record.send("#{@naming_prefix}_#{part}")
      end

      define_method "#{part}=" do |value|
        @record.send("#{@naming_prefix}_#{part}=", value)
      end
    end

    def to_s
      full_name
    end

    private

    attr_reader :naming_prefix, :record
  end
end