require "google/api_client"

class CalendarService
  attr_accessor :service

  def initialize(user)
    @user = user
    @client = Google::APIClient.new({
      application_name: 'AssistantHarmony',
      application_version: '1.0.0'
    })
    @client.authorization.access_token = @user.token
    @service = @client.discovered_api('calendar', 'v3')
  end

  def calendar_list
    json = @client.execute({
      api_method: @service.calendar_list.list,
      parameters: {},
      headers: {'Content-Type' => 'application/json'}
    })

    JSON.parse(json.response.env[:body])["items"].map do |calendar_json|
      Calendar.parse calendar_json
    end
  end

  def calendar_get(calendar_id)
    json = @client.execute({
      api_method: @service.calendars.get,
      parameters: {calendarId: id},
      headers: {'Content-Type' => 'application/json'}
    })
  end

  def events_list(calendar_id)
    @client.execute({
      api_method: @service.events.list,
      parameters: {
      },
      headers: {'Content-Type' => 'application/json'}
    }).response.env[:body]
  end
end
