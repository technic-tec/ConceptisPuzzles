require 'google/api_client/client_secrets'

CLIENT_SECRETS = Rails.application.config.x.CLIENT_SECRETS = Google::APIClient::ClientSecrets.load
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV[CLIENT_SECRETS.client_id],
    ENV[CLIENT_SECRETS.client_secret], {
      :scope => ['profile', 'email'],
      :approval_prompt => "auto",
      :include_granted_scopes => true
    }
end
