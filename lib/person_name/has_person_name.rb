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
	    end

			module ClassMethods
				def initialize_person_names
					name_types.map(&:to_s).each do |name_type|
						class_eval %(
							def #{name_type}
								person_name_for('#{name_type}')
							end

							def #{name_type}= new_name
								set_person_name_for('#{name_type}', new_name)
							end
						)
					end
				end
			end

			module InstanceMethods

				def person_name_for field
					@person_names ||= {}
					@person_names[field] ||= PersonName::ActiveRecordPersonName.new(field, self)
				end

				def set_person_name_for field, new_name
					person_name_for(field).full_name = new_name
				end

			end

		end

	end

end