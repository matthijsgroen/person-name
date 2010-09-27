ActiveRecord::Schema.define :version => 0 do
  create_table "people", :force => true do |t|
    t.person_name :name
  end

  create_table "person_without_names", :force => true do |t|
    t.boolean   :female
  end

  create_table "name_people", :force => true do |t|
    t.person_name :name
    t.person_name :birth_name
    t.boolean   :female
  end

end
