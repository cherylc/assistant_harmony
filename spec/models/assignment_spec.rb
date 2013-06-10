require 'spec_helper'

describe Assignment do
  let(:start_at) { Date.today }
  let(:valid_attributes) do
    {
      user_id: 1,
      recipients: ['cheryl.crouse@gmail.com'],
      schedule_start_at: start_at
    }
  end

  describe "instantiating an assignment" do
    describe "a user_id" do
      it "is required" do
        Assignment.new(valid_attributes.merge(user_id: nil)).should_not be_valid
      end
    end
  end

  describe "scheduling a meeting" do
    def generate_meeting(datetime, increment)
      Meeting.new do |meeting|
        meeting.user_id = 1
        meeting.key = SecureRandom.uuid
        meeting.start_at = datetime.midnight
        meeting.end_at = datetime.midnight + increment
      end
    end

    describe "with an hour increment" do
      it "can schedule a meeting" do
        assignment = Assignment.new(valid_attributes)
        meeting = generate_meeting(assignment.schedule_start_at, 1.hour)

        assignment.schedule(meeting).should be_true
      end

      it "cannot duplicate a meeting by user, start, and end" do
        assignment = Assignment.new(valid_attributes)
        meeting = generate_meeting(assignment.schedule_start_at, 1.hour)

        assignment.schedule(meeting)
        assignment.schedule(meeting).should be_false
      end
    end
  end
end
