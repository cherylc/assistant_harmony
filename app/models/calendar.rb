class Calendar < ActiveRecord::Base
  attr_accessible :user_id, :external_id, :name, :time_zone

  validates :user_id,     presence: true
  validates :external_id, presence: true, length: {maximum: 100}
  validates :name,        presence: true, length: {maximum: 100}
  validates :time_zone,   presence: true, length: {maximum: 50}

  belongs_to :user

  def self.parse(json_input)
    json = json_input.symbolize_keys

    Calendar.new({
      external_id: json[:id],
      name: json[:summary],
      time_zone: json[:timeZone]
    })
  end

  def events
    google = GoogleService.new(user, {name: 'calendar', version: 'v3'})
    json = google.query({
      method: google.service.events.list,
      parameters: {
        calendarId: external_id,
        timeMin: "2013-05-12T07:41:03.760Z",
        timeMax: "2013-05-20T07:41:03.760Z"
      }
    })
  end
end
