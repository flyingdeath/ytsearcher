class LoginController < ApplicationController

  skip_before_filter :auth_start_app, :only => [:auth_start, :oauth2callback]





  def auth_start
    unless session[:authing]

# REPLACE WITH VALID REDIRECT_URI FOR YOUR CLIENT
  @REDIRECT_URI = 'http://localhost'
  @APPLICATION_NAME = 'YouTube Data API Ruby Tests'

# REPLACE WITH NAME/LOCATION OF YOUR client_secrets.json FILE
  @CLIENT_SECRETS_PATH = 'client_secret.json'

# REPLACE FINAL ARGUMENT WITH FILE WHERE CREDENTIALS WILL BE STORED
  @CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                                "youtube-quickstart-ruby-credentials.yaml")

# SCOPE FOR WHICH THIS SCRIPT REQUESTS AUTHORIZATION
  @SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL 
      FileUtils.mkdir_p(File.dirname(@CREDENTIALS_PATH))

      client_id = Google::Auth::ClientId.from_file(@CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: @CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(
          client_id, @SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        @auth_url  = authorizer.get_authorization_url(base_url: @REDIRECT_URI)
        render '/login/auth_start'
      else

        @@service = Google::Apis::YoutubeV3::YouTubeService.new
        @@service.client_options.application_name = @APPLICATION_NAME
        @@service.authorization = credentials
        redirect_to  session[:request_url]
      end
    end
  end

  def oauth2callback
    session[:authing] = false

# REPLACE WITH VALID REDIRECT_URI FOR YOUR CLIENT
  @REDIRECT_URI = 'http://localhost'
  @APPLICATION_NAME = 'YouTube Data API Ruby Tests'

# REPLACE WITH NAME/LOCATION OF YOUR client_secrets.json FILE
  @CLIENT_SECRETS_PATH = 'client_secret.json'

# REPLACE FINAL ARGUMENT WITH FILE WHERE CREDENTIALS WILL BE STORED
  @CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                                "youtube-quickstart-ruby-credentials.yaml")

# SCOPE FOR WHICH THIS SCRIPT REQUESTS AUTHORIZATION
  @SCOPE = Google::Apis::YoutubeV3::AUTH_YOUTUBE_FORCE_SSL 
    FileUtils.mkdir_p(File.dirname(@CREDENTIALS_PATH))
      client_id = Google::Auth::ClientId.from_file(@CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: @CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(
          client_id, @SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: params[:code], base_url: @REDIRECT_URI)

      @@service = Google::Apis::YoutubeV3::YouTubeService.new
      @@service.client_options.application_name = @APPLICATION_NAME
      @@service.authorization = credentials
    redirect_to  session[:request_url]
  end
  
end
