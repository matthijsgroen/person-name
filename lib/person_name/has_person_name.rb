module PersonName

  module ActiveRecord

    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods

      def has_person_names?
        false
      end

      def has_person_name(*name_types)
        name_types = name_types.to_a.flatten.compact.map(&:to_sym)
        name_types << :name if name_types.empty?

        if has_person_names?
          write_inheritable_attribute(:name_types, (self.name_types + name_types).uniq)
        else
          write_inheritable_attribute(:name_types, name_types)
          class_inheritable_reader(:name_types)

          class_eval do
            def self.has_person_names?
              true
            end

            include PersonName::ActiveRecord::Core
          end
        end
      end

    end

    module Core

      def self.included(base)
        base.extend PersonName::ActiveRecord::Core::ClassMethods
        base.send :include, PersonName::ActiveRecord::Core::InstanceMethods
        base.initialize_person_names

        base.before_validation :start_name_validation
        base.after_validation :stop_name_validation
        base.before_save :cache_full_names
        #base.define_scopes
      end

      module ClassMethods

        def initialize_person_names
          name_types.map(&:to_s).each do |name_type|
            script = %(
              def #{name_type}
                person_name_for('#{name_type}')
              end
            )
            script += %(
              def #{name_type}= new_name
                set_person_name_for('#{name_type}', new_name)
              end
            )
            class_eval script
          end
        end

#        def define_scopes
#          name_types.map(&:to_s).each do |field_name|
#            concat_construct = [%(IFNULL(`#{field_name}_prefix`, ""))]
#            [:first_name, :middle_name, :intercalation, :last_name, :suffix].each { |element|
#              concat_construct << %(IF(ISNULL(`#{field_name}_#{element}`), "", CONCAT(" ", `#{field_name}_#{element}`)))
#            }
#            script = %(
#              scope :with_#{field_name}, lambda { |name|
#                where('TRIM(CONCAT(#{concat_construct.join(", ")})) = ?', name)
#              }
#              def find_by_#{field_name}(name)
#                self.with_#{field_name}(name).first
#              end
#            )
#            puts script
#            instance_eval script
#          end
#        end

      end

      module InstanceMethods

        # when using forms to edit the full name or the indiviual form parts
        # it is possible that both fields (The aggregated one _and_ the individual ones)
        # get posted back to the model. So, wich fields are the correct edited ones?
        #
        # To determine this, we use this development mantra:
        # 1. If the user is able to edit it in one field, he should.
        #   Therefore, if the aggregated field is posted, this is the most recent one
        #   and should override the seperated parts
        # 2. If only individual parts are edited, there should not be an aggregated
        #   value in the form
        # 3. If the view allowes the user to edit the aggregated field and the seperated fields,
        #   the field should make sure the values are comparable (eg. the separated values combined
        #   should be equal to the aggregated one). If this is the case, the separated fields
        #   will rule over the aggregated one, since it is more detailed and adds up to the same result.
        def attributes=(new_attributes, guard_protected_attributes = true)
          return unless new_attributes.is_a?(Hash)
          attributes = new_attributes.stringify_keys

          self.class.name_types.map(&:to_s).each do |name_base|
            if attributes.has_key? name_base # only add behaviour if the full name is supplied
              full = attributes[name_base]

              existing_part_fields = []
              part_values = []
              part_hash = {}
              PersonName::NameSplitter::NAME_PARTS.each do |name_part|
                test_field = "#{name_base}_#{name_part}"
                if attributes.has_key? test_field
                  existing_part_fields << test_field
                  part_values << attributes[test_field]
                  part_hash[name_part.to_sym] = attributes[test_field]
                else
                  part_values << send(test_field.to_sym)
                end
              end
              if part_values.compact.join(" ") == full
                attributes.delete name_base
              else
                # try to use existing fields as editing values of full name
                new_part_values = PersonName::NameSplitter.split(attributes[name_base], part_hash)
                assignments_valid = nil

                # test if there is no conflict
                PersonName::NameSplitter::NAME_PARTS.each do |name_part|
                  test_field = "#{name_base}_#{name_part}"
                  if attributes.has_key? test_field
                    attributes[test_field] = new_part_values[name_part.to_sym]
                    assignments_valid = true if assignments_valid.nil?
                  else
                    assignments_valid = false unless new_part_values[name_part.to_sym].nil?
                  end
                end

                if assignments_valid
                  attributes.delete name_base
                else
                  existing_part_fields.each do |part_field|
                    attributes.delete part_field
                  end
                end
              end
            end
          end

          super attributes, guard_protected_attributes
        end

        private

        def person_name_for field
          @person_names ||= {}
          @person_names[field] ||= PersonName::ActiveRecordPersonName.new(field, self)
          @name_validation ? @person_names[field].full_name : @person_names[field]
        end

        def set_person_name_for field, new_name
          write_attribute(field, new_name)
          person_name_for(field).full_name = new_name
        end

        def start_name_validation
          @name_validation = true
        end

        def stop_name_validation
          @name_validation = false
        end

        def cache_full_names
          self.class.name_types.map(&:to_s).each do |name_type|
            write_attribute(name_type.to_sym, person_name_for(name_type).full_name)
          end
        end

      end

    end

  end

end