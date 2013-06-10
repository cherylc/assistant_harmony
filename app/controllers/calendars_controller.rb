class CalendarsController < ApplicationController
  before_filter :authenticate, only: [:subscribe]

  def subscribe
    calendar = current_user.calendars.find(params[:calendar_id])
    calendar.selected = params[:selected] == "true" ? true : false
    calendar.save if calendar.changed?

    redirect_to profile_path
  end
end
