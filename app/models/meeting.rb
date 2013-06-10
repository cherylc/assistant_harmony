class Meeting < ActiveRecord::Base
  attr_accessible :state

  belongs_to :user
  belongs_to :assignment

  before_create do |assignment|
    assignment.key = SecureRandom.uuid
  end

  def display_times
    "#{start_at.to_s(:long)} - #{end_at.to_s(:long)}"
  end

  def create_google_event
    update_attributes(state: "scheduled")
    google = GoogleService.new(user, {name: 'calendar', version: 'v3'})
    google.query({
      method: google.service.events.insert,
      parameters: {
        calendarId: user.email,
        sendNotifications: true,
      },
      body: JSON.dump(event_body)
    })
  end

  def event_body
    {
      attendees: attendees_list,
      description: "Shocking people at W-paycheck",
      location: "Not yet sure how to define this...",
      status: event_status,
      start: {
        dateTime: start_at.to_s(:rfc3339)
      },
      end: {
        dateTime: end_at.to_s(:rfc3339)
      },
      summary: "Eating Ice Cream and Prosecco"
    }
  end

  def event_status
    state == 'scheduled' ? 'tentative' : 'confirmed'
  end

  def attendees_list
    assignment.recipients.inject([]) do |attendees, recipient|
      attendee = User.where(email: recipient.email).first

      hash = {email: recipient.email}
      hash[:displayName] = attendee.name if attendee

      attendees << hash
      attendees
    end
  end
end
