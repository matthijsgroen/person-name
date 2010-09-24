require File.expand_path('../../spec_helper', __FILE__)

describe "Has Person Name" do
  before(:each) do
    clean_database!
  end

  describe "Automatic name assignment" do
    before(:each) do
      clean_database!
      @person = Person.new
    end

    it "should have an accessor for the defined name fields" do
      @person.should respond_to(:name)
    end

  end

  describe "Automatic name assignment" do
    before(:each) do
      clean_database!
      @person = Person.new
    end

    it "should assign name parts to the correct fields" do
      @person.name = "Matthijs Groen"
      @person.name.first_name.should == "Matthijs"
    end

  end

#  it "should provide a class method 'taggable?' that is false for untaggable models" do
#    UntaggableModel.should_not be_taggable
#  end

#  describe "Taggable Method Generation" do
#    before(:each) do
#      clean_database!
#      TaggableModel.write_inheritable_attribute(:tag_types, [])
#      TaggableModel.acts_as_taggable_on(:tags, :languages, :skills, :needs, :offerings)
#      @taggable = TaggableModel.new(:name => "Bob Jones")
#    end
#
#    it "should respond 'true' to taggable?" do
#      @taggable.class.should be_taggable
#    end
#
#    it "should create a class attribute for tag types" do
#      @taggable.class.should respond_to(:tag_types)
#    end
#
#    it "should create an instance attribute for tag types" do
#      @taggable.should respond_to(:tag_types)
#    end
#
#    it "should have all tag types" do
#      @taggable.tag_types.should == [:tags, :languages, :skills, :needs, :offerings]
#    end
#
#    it "should generate an association for each tag type" do
#      @taggable.should respond_to(:tags, :skills, :languages)
#    end
#
#    it "should add tagged_with and tag_counts to singleton" do
#      TaggableModel.should respond_to(:tagged_with, :tag_counts)
#    end
#
#    it "should generate a tag_list accessor/setter for each tag type" do
#      @taggable.should respond_to(:tag_list, :skill_list, :language_list)
#      @taggable.should respond_to(:tag_list=, :skill_list=, :language_list=)
#    end
#
#    it "should generate a tag_list accessor, that includes owned tags, for each tag type" do
#      @taggable.should respond_to(:all_tags_list, :all_skills_list, :all_languages_list)
#    end
#  end

#  describe "Single Table Inheritance" do
#    before do
#      @taggable = TaggableModel.new(:name => "taggable")
#      @inherited_same = InheritingTaggableModel.new(:name => "inherited same")
#      @inherited_different = AlteredInheritingTaggableModel.new(:name => "inherited different")
#    end
#
#    it "should pass on tag contexts to STI-inherited models" do
#      @inherited_same.should respond_to(:tag_list, :skill_list, :language_list)
#      @inherited_different.should respond_to(:tag_list, :skill_list, :language_list)
#    end
#
#    it "should have tag contexts added in altered STI models" do
#      @inherited_different.should respond_to(:part_list)
#    end
#  end

end
