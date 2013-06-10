class ProfilesController < ApplicationController
  before_filter :authenticate, only: [:show, :load]

  def show
    @user = current_user
    @calendars = current_user.calendars.map{|c| [c.name, c.id]}
  end

  def load
    CalendarService.new(current_user).calendar_list.each do |calendar|
      unless current_user.calendars.where(external_id: calendar.external_id).present?
        current_user.calendars << calendar
      end
    end

    current_user.save

    redirect_to profile_path
  end
end
