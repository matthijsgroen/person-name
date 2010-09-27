class Person < ActiveRecord::Base
  has_person_name
end

class PersonWithoutName < ActiveRecord::Base
end

class NamePerson < ActiveRecord::Base
  has_person_name
  has_person_name :birth_name
end
