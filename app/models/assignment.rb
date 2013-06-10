class Assignment < ActiveRecord::Base
  attr_accessible :user_id, :schedule_start_at

  validates :user_id,   presence: true

  belongs_to :user
  has_many :meetings, dependent: :destroy
  has_many :recipients, dependent: :destroy

  def schedule_meetings(options = {increment: 1.hour, amount: 3})
    options[:amount].to_i.times do
      while !schedule(increment: options[:increment])
        puts "executing schedule, meeting already exists"
      end
    end
  end

  def google_busy_events
    return @google_busy_events if @google_busy_events

    google = GoogleService.new(user, {name: 'calendar', version: 'v3'})
    json = JSON.parse(google.query({
      method: google.service.freebusy.query,
      body: {
        items: user.selected_calendars.map{ |c| {id: c.external_id} },
        timeMin: schedule_start_at.to_s(:rfc3339),
        timeMax: (schedule_start_at + 7.days).to_s(:rfc3339)
      }
    }).response.env[:body])

    @google_busy_events = json["calendars"]
                            .map{ |id, busy_events| busy_events["busy"] }
                            .flatten
                            .sort{ |a,b| a["start"] <=> b["start"] }
  end

  def meeting_exists?(meeting)
    meetings.detect{|m| m.start_at == meeting.start_at && m.end_at == meeting.end_at}.present?
  end

  def schedule(options = {})
    success = false

    meeting = options[:meeting] || random_meeting(options[:increment])

    unless meeting_exists?(meeting)
      meetings << meeting
      success = true
    end

    success
  end

  def random_meeting(increment = 1.hour, range_increment = 7.days)
    start_at = DateTime.parse("#{random_date(range_increment)} #{random_time}")

    Meeting.new do |meeting|
      meeting.user_id = self.user_id
      meeting.key = SecureRandom.uuid
      meeting.start_at = start_at
      meeting.end_at = start_at + increment
    end
  end

  def random_date(increment = 7.days)
    rand (schedule_start_at.to_date)..(schedule_start_at.to_date + increment)
  end

  def random_time
    rand 8..18 # Derive this from the user profile later
  end
end
