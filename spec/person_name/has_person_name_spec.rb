require File.expand_path('../../spec_helper', __FILE__)

describe "Has Person Name" do
  before(:each) do
    clean_database!
  end

  describe "Some model without names" do
    it "should not have person names" do
      PersonWithoutName.should_not have_person_names
    end
  end

  describe "Some model with names" do
    it "should have person names" do
      Person.should have_person_names
    end
  end

  describe "Automatic name assignment" do
    before(:each) do
      clean_database!
      @person = Person.new
    end

    it "should have an accessor for the defined name fields" do
      @person.should respond_to(:name)
    end

    it "should read active_record attributes" do
      @person.name_first_name = "Matthijs"
      @person.name.first_name.should == "Matthijs"

      @person.name_last_name = "Groen"
      @person.name.last_name.should == "Groen"

      @person.name.to_s.should == "Matthijs Groen"
    end

    it "should assign active_record attributes" do
      @person.name.first_name = "Matthijs"
      @person.name_first_name.should == "Matthijs"

      @person.name.last_name = "Groen"
      @person.name_last_name.should == "Groen"
    end

    it "should be able to show a short name" do
      @person.name = "Matthijs Jacobus Groen"
      @person.name.short_name.should == "M.J. Groen"
      @person.name.short_name(false).should == "M. Groen"
    end

    it "should be able to show a full last name" do
      @person.name = "Frans van der Sluis"
      @person.name.full_last_name.should == "van der Sluis"
    end

    it "should split up name parts and assign to correct fields" do
      test_fields = %w(prefix first_name middle_name intercalation last_name suffix)
      test_cases = [
        [nil, "Matthijs", nil, nil, "Groen", nil],
        [nil, "Matthijs", "Jacobus", nil, "Groen", nil],
        [nil, "Frans", nil, "van der", "Sluis", "Phd."],
        [nil, "Maria", "Cornelia Hendrina", nil, "Damen-van Valenberg", nil],
        ["Mevr.", "Maria", "Cornelia Hendrina", nil, "Damen - van Valenberg", nil],
        [nil, "Maria", "Cornelia Hendrina", nil, "Damen- van Valenberg", nil],
        [nil, "Maria", "Cornelia Hendrina", nil, "Damen -van Valenberg", nil],
        [nil, "Maria", "Cornelia Hendrina", "van", nil, nil],
        [nil, "- Maria", "Cornelia Hendrina", "van", "Dingen-", nil],
        ["Mevr.", "Maria", "Mej. Cornelia Hendrina", "van", "Dingen -", nil],
        [nil, "Maria", "Cornelia Hendrina", "van", "Dingen-van", nil],
        [nil, "Maria", "Cornelia Hendrina", "van", "Groen-Teboer", nil],
        [nil, "Maria", "Cornelia Hendrina", "van", "Groen-van Phd. Lala", "jr."],
        [nil, "Maria", "Cornelia Hendrina", "van", "Groen-van", "Phd. jr."],
        [nil, "Dirk", "Jan", "van de", "Abeele", nil],
        [nil, "Yolanthe", "Cabau", "van", "Kasbergen", nil],
      ]

      test_cases.each do |fields|
        string = fields.compact.join(" ")
        @person = Person.new
        @person.name = string

        #puts "in #{fields.inspect}"
        test_fields.each_with_index do |field, index|
          @person.name.send(field).should == fields[index]
        end
      end
    end

    it "should remember corrections" do
      @person.name.first_name = "Yolanthe"
      @person.name.last_name = "Cabau van Kasbergen"

      @person.name = "Yolanthe Truuske Cabau van Kasbergen"
      @person.name.middle_name.should == "Truuske"
      @person.name.last_name.should == "Cabau van Kasbergen"
    end

    it "should accept a nil value" do
      @person.name = nil
      @person.save

      @person.name.to_s.should == ""
    end

  end

  describe "active record specifics" do

    it "should have a working with_name scope" do
      clean_database!
      @person = Person.new :name => "Matthijs Jacobus Groen"
      @person.save

      Person.find_by_name("Matthijs Jacobus Groen").should == @person
    end

    it "should validate names" do
      @person = NamePerson.new :name => "Matthijs Groen"
      @person.should_not be_valid
      @person.birth_name = "Matthijs Jacobus Groen"
      @person.should be_valid
    end

    it "should use the full name if post attributes don't match" do
      @person = NamePerson.new
      @person.attributes = {
              :name_first_name => "Henk",
              :name_middle_name => "Jacobus",
              :name_last_name => "Groen",
              :name => "Matthijs Jacobus Groen"
      }
      @person.name.to_s.should == "Matthijs Jacobus Groen"
    end

    it "should use the individual fields if post attributes match" do
      @person = NamePerson.new
      @person.attributes = {
              :name => "Matthijs Jacobus Groen",
              :name_first_name => "Matthijs",
              :name_middle_name => nil,
              :name_last_name => "Jacobus Groen"
      }
      @person.name.to_s.should == "Matthijs Jacobus Groen"
      @person.name.last_name.should == "Jacobus Groen"

    end


  end

end
