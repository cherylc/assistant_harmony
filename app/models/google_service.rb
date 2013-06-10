require "google/api_client"

class GoogleService
  attr_reader :service

  def initialize(user, api_hash)
    @client = Google::APIClient.new({
      application_name: 'AssistantHarmony',
      application_version: '1.0.0'
    })
    @client.authorization.client_id = PROVIDERS[:google_oauth2][:key]
    @client.authorization.client_secret = PROVIDERS[:google_oauth2][:secret]
    @client.authorization.scope = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar"

    @client.authorization.access_token = user.token
    @client.authorization.refresh_token = user.refresh_token

    if @client.authorization.refresh_token && @client.authorization.expired?
      @client.authorization.fetch_access_token!
    end

    @service = @client.discovered_api(api_hash[:name], api_hash[:version])
  end

  def query(options)
    Rails.logger.info "execute:\n#{
      {
        api_method: options[:method],
        parameters: options[:parameters] || {},
        body: JSON.dump(options[:body]),
        headers: options[:headers] || {'Content-Type' => 'application/json'}
      }
    }"

    @client.execute({
      api_method: options[:method],
      parameters: options[:parameters] || {},
      body: JSON.dump(options[:body]),
      headers: options[:headers] || {'Content-Type' => 'application/json'}
    })
  end
end
