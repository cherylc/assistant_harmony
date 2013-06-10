require 'spec_helper'

describe Calendar do
  let(:valid_attributes) do
    {
      user_id: 1,
      external_id: "chad.pry@gmail.com",
      name: "Chad W Pry",
      time_zone: "Chicago/America"
    }
  end

  describe "instantiating a calendar" do
    describe "an user_id" do
      it "is required" do
        Calendar.new(valid_attributes.merge(user_id: nil)).should_not be_valid
      end
    end

    describe "an external_id" do
      it "is required" do
        Calendar.new(valid_attributes.merge(external_id: nil)).should_not be_valid
      end

      it "limits the size to 100 characters" do
        Calendar.new(valid_attributes.merge(external_id: "1" * 100)).should be_valid
        Calendar.new(valid_attributes.merge(external_id: "1" * 101)).should_not be_valid
      end
    end

    describe "a name" do
      it "is required" do
        Calendar.new(valid_attributes.merge(name: nil)).should_not be_valid
      end

      it "limits the size to 100 characters" do
        Calendar.new(valid_attributes.merge(name: "1" * 100)).should be_valid
        Calendar.new(valid_attributes.merge(name: "1" * 101)).should_not be_valid
      end
    end

    describe "a time zone" do
      it "is required" do
        Calendar.new(valid_attributes.merge(time_zone: nil)).should_not be_valid
      end

      it "limits the size to 50 characters" do
        Calendar.new(valid_attributes.merge(time_zone: "1" * 50)).should be_valid
        Calendar.new(valid_attributes.merge(time_zone: "1" * 51)).should_not be_valid
      end
    end

    describe ".parse" do
      describe "when passed valid json" do
        it "sets an id as external_id" do
          Calendar.parse(id: "chad.pry@gmail.com").external_id.should == "chad.pry@gmail.com"
          Calendar.parse("id" => "chad.pry@gmail.com").external_id.should == "chad.pry@gmail.com"
        end

        it "sets a summary as name" do
          Calendar.parse(summary: "chad.pry@gmail.com").name.should == "chad.pry@gmail.com"
          Calendar.parse("summary" => "chad.pry@gmail.com").name.should == "chad.pry@gmail.com"
        end
        
        it "sets a timeZone as time_zone" do
          Calendar.parse(timeZone: "Chicago/America").time_zone.should == "Chicago/America"
          Calendar.parse("timeZone" => "Chicago/America").time_zone.should == "Chicago/America"
        end
      end
    end
  end
end
