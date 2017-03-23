# Manages connections to various Google APIs.
class GoogleService
  def client
    @client ||=
      begin
        client = Signet::OAuth2::Client.new({
          client_id: Setting.fetch(:google_client_id),
          client_secret: Setting.fetch(:google_client_secret),
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        })

        client.update!(refresh_token: Setting.fetch(:google_refresh_token))
        client.grant_type = 'refresh_token'
        client
      end
  end
end
