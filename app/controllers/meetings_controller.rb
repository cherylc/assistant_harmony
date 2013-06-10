class MeetingsController < ApplicationController
  before_filter :authenticate

  def reject
    meeting = current_user.meetings.where(key: params[:id]).first

    if meeting
      meeting.update_attributes(state: "rejected")
      redirect_to profile_assignment_path(meeting.assignment)
    end
  end

  def schedule
    meeting = current_user.meetings.where(key: params[:id]).first

    if meeting
      meeting.create_google_event
      redirect_to profile_assignment_path(meeting.assignment)
    end
  end
end
