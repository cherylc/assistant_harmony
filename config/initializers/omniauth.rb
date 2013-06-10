PROVIDERS = YAML.load_file('config/omniauth.yml')[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  PROVIDERS.each do |oauth_provider, oauth_config|
    provider oauth_provider, oauth_config[:key], oauth_config[:secret], oauth_config[:extra]
  end
end if PROVIDERS
