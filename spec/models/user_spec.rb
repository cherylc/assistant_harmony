require 'spec_helper'

describe User do
  let(:valid_attributes) do
    {
      provider: "google_oauth2", uid: 1234567890,
      token: 12345678901234567890,
      refresh_token: 12345678901234567890,
      expires_at: 1368417546,
      name: "Chad W Pry", email: "chad.pry@gmail.com",
      gender: 2, locale: "en",
      image: "https://lh6.googleusercontent.com/-vnRifM5wHXw/AAAAAAAAAAI/AAAAAAAAA_o/s0nmcom0Hz0/photo.jpg"
    }
  end

  describe "instantiating a user" do
    describe "a provider" do
      it "is required" do
        User.new(valid_attributes.merge(provider: nil)).should_not be_valid
      end

      it "allows google_oauth2" do
        User.new(valid_attributes).should be_valid
      end

      it "only allows google_oauth2" do
        User.new(valid_attributes.merge(provider: "github")).should_not be_valid
      end
    end

    describe "a uid" do
      it "is required" do
        User.new(valid_attributes.merge(uid: nil)).should_not be_valid
      end

      it "limits the size to 25 characters" do
        User.new(valid_attributes.merge(uid: "1" * 25)).should be_valid
        User.new(valid_attributes.merge(uid: "1" * 26)).should_not be_valid
      end
    end

    describe "a token" do
      it "is required" do
        User.new(valid_attributes.merge(token: nil)).should_not be_valid
      end

      it "limits the size to 64 characters" do
        User.new(valid_attributes.merge(token: "1" * 64)).should be_valid
        User.new(valid_attributes.merge(token: "1" * 65)).should_not be_valid
      end
    end

    describe "a name" do
      it "is required" do
        User.new(valid_attributes.merge(name: nil)).should_not be_valid
      end

      it "limits the size to 100 characters" do
        User.new(valid_attributes.merge(name: "1" * 100)).should be_valid
        User.new(valid_attributes.merge(name: "1" * 101)).should_not be_valid
      end
    end

    describe "an email" do
      it "is required" do
        User.new(valid_attributes.merge(email: nil)).should_not be_valid
      end

      it "limits the size to 255 characters" do
        User.new(valid_attributes.merge(email: "1" * 255)).should be_valid
        User.new(valid_attributes.merge(email: "1" * 256)).should_not be_valid
      end
    end

    describe "a gender" do
      it "only allows 0 (unknown) or 1 (female) or 2 (male)" do
        User.new(valid_attributes.merge(gender: 1)).should be_valid
        User.new(valid_attributes.merge(gender: 2)).should be_valid
        User.new(valid_attributes.merge(gender: 0)).should be_valid
        User.new(valid_attributes.merge(gender: 3)).should_not be_valid
      end

      it "recognizes 1 as female" do
        User.new(gender: 1).should be_female
      end

      it "recognizes 1 as male" do
        User.new(gender: 2).should be_male
      end
    end

    describe "a locale" do
      it "limits the locale to 5 characters" do
        User.new(valid_attributes.merge(locale: "e" * 5)).should be_valid
        User.new(valid_attributes.merge(locale: "e" * 6)).should_not be_valid
      end
    end

    describe "a image" do
      it "limits the image to 255 characters" do
        User.new(valid_attributes.merge(image: "e" * 255)).should be_valid
        User.new(valid_attributes.merge(image: "e" * 256)).should_not be_valid
      end
    end

    describe "constraints" do
      it "is unique based on provider and uid" do
        User.create(valid_attributes)
        User.new(valid_attributes).should_not be_valid
      end

      it "is unique based on email" do
        User.create(valid_attributes.merge(uid: 1111111111, email: "chad.pry@gmail.com"))
        User.new(valid_attributes.merge(uid: 4444444444, email: "chad.pry@gmail.com")).should_not be_valid
      end

      it "is unique based on EmAiL" do
        User.create(valid_attributes.merge(uid: 1111111111, email: "chad.pry@gmail.com"))
        User.new(valid_attributes.merge(uid: 4444444444, email: "chad.PRY@gmail.com")).should_not be_valid
      end
    end
  end
end
