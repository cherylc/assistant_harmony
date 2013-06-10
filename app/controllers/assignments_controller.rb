class AssignmentsController < ApplicationController
  before_filter :authenticate

  def index
    @assignments = current_user.assignments.order('created_at asc')
  end

  def show
    @zone = ActiveSupport::TimeZone.new("Central Time (US & Canada)")
    @assignment = current_user.assignments.find(params[:id])
    @meetings = @assignment.meetings.order('start_at')
  end

  def create
    Rails.logger.info params[:assignment].merge(user_id: current_user.id)

    recipients = params[:assignment].delete(:recipient).split(",").map do |email|
      Recipient.new(email: email)
    end

    @assignment = Assignment.new(params[:assignment].merge({
      user_id: current_user.id, schedule_start_at: Time.now + 1.day
    }))

    recipients.each do |recipient|
      @assignment.recipients << recipient
    end
    
    if @assignment.save
      redirect_to profile_assignments_path
    end
  end

  def destroy
    user = current_user.assignments.find(params[:id])
    user.destroy

    redirect_to profile_assignments_path
  end

  def schedule
    assignment = current_user.assignments.find(params[:id])

    if assignment
      assignment.schedule_meetings({
        increment: 1.hour, amount: params[:amount] || 3
      })
      redirect_to profile_assignment_path(assignment)
    end
  end
end
