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
        base.send :include, PersonName::ActiveRecord::Core::InstanceMethods
        base.extend PersonName::ActiveRecord::Core::ClassMethods
        base.initialize_person_names
        base.before_validation :start_name_validation
        base.after_validation :stop_name_validation
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

        def person_name_for field
          @person_names ||= {}
          @person_names[field] ||= PersonName::ActiveRecordPersonName.new(field, self)
          @name_validation ? @person_names[field].full_name : @person_names[field]
        end

        def set_person_name_for field, new_name
          write_attribute(field, new_name)
          person_name_for(field).full_name = new_name
        end

        private

        def start_name_validation
          @name_validation = true
        end

        def stop_name_validation
          @name_validation = false
        end

      end

    end

  end

end