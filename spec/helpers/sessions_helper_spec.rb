require 'spec_helper'

describe SessionsHelper do
  describe "#auth_signin" do
    describe "with google_oauth2 as a provider" do
      it "creates an absolute provider url" do
        helper.auth_signin(:google_oauth2).should == "/auth/google_oauth2"
      end
    end

    describe "with github as a provider" do
      it "creates an absoulte provider url" do
        helper.auth_signin(:github).should == "/auth/github"
      end
    end
  end
end
