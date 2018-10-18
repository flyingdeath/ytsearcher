class ApplicationController < ActionController::Base


  require 'google/apis'
  require 'google/apis/youtube_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'

  require 'fileutils'
  require 'json'

  protect_from_forgery
  



  cert_path = Gem.loaded_specs['google-api-client'].full_gem_path+'/lib/cacerts.pem'
  ENV['SSL_CERT_FILE'] = cert_path

  before_filter :auth_start_app
  
  
  def auth_start_app
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
      session[:request_url] = request.url
      redirect_to  :controller => 'login', :action =>  "auth_start"
    else


    end

  end
  
end
