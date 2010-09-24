ActiveRecord::Schema.define :version => 0 do
  create_table "people", :force => true do |t|
    t.string   "name_prefix"
    t.string   "name_first_name"
    t.string   "name_middle_name"
    t.string   "name_intercalation"
    t.string   "name_last_name"
    t.string   "name_suffix"
  end

end
