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

    it "should split up name parts and assign to correct fields" do
      test_fields = %w(prefix first_name middle_name intercalation last_name suffix)
      test_cases = [
        [nil, "Matthijs", nil, nil, "Groen", nil],
        [nil, "Matthijs", "Jacobus", nil, "Groen", nil],
        [nil, "Frans", nil, "van der", "Sluis", nil],
        [nil, "Maria", "Cornelia Hendrina", nil, "Damen-van Valenberg", nil],
        [nil, "Dirk", "Jan", "van de", "Abeele", nil],
        [nil, "Yolanthe", "Cabau", "van", "Kasbergen", nil],
      ]

      test_cases.each do |fields|
        string = fields.compact.join(" ")
        @person = Person.new
        @person.name = string

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

  end

end
