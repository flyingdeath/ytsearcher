
class MainpageController < ApplicationController


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

  @@service = Google::Apis::YoutubeV3::YouTubeService.new
  @@service.client_options.application_name = @APPLICATION_NAME
  @@service.authorization = credentials

  def search


   items = {}
   @list = {}
   @searchText = ""
   @title = ""
   temp = nil
   if !params[:Topic].nil? 
        topics = params[:Topic][:c].to_s
   end
   
   
   if topics != ""
     @topics = topics
   else
     @topics = ""
     t = [""]
   end 
   

   
   
   if params[:search]
     @searchText = params[:search]
   end
   
   if params[:commit] == "Load" and params[:title] != "" and params[:title] 
     @searchText =  getPlaylistTitles(params[:title])
     @title = params[:title]
   end
   
   if @searchText != ""
     terms = params[:search].split("\r\n")
    # terms.each{|t| t.gsub!(/'/,"\\\\'")}
     if terms
       terms.each{|term|
         begin
           #temp =  client.videos_by(:query => term, :categories => c, :tags => t)

           temp = @@service.list_searches( 'snippet',{:type => "video", :q =>term, :max_results => 25, :topic_id => @topics})
           if temp 
             items[term] = temp
           end 
         rescue
          
         end
         
       }
       
       x = 1
       @total_items = 0
       
        items.each{|v,item|
          @list[v] = []
          x = 1
          item.items.each{|i|
            
            @total_items += 1
            
            html_options = {:dataMeta => 'dataMeta'}
            
            if x == 1 
              html_options[:selected] = 'selected'
            end 
          
            @list[v] << [i.snippet.title, html_options,
                         i.snippet.description, i.snippet.thumbnails.default.url,
                         i.snippet.published_at, i.snippet.channel_id,
                         i.snippet.channel_title, i.id.video_id]
            x += 1
          }
        }
      end 
    end 
    
  end

  def loadWatchLater
   # render :text => "hello" + params[:id]
    addToPlayList = (params["title"] != "" and params["title"])
    if addToPlayList
      pList = playlistExists( params["title"])
      if pList.nil?
        resource = create_resource({'snippet.title': params["title"],
                                    'snippet.description': '',
                                    'snippet.tags[]': '',
                                    'snippet.default_language': '',
                                    'status.privacy_status': ''}) # See full sample for function
        pList = @@service.insert_playlist('snippet,status', resource, {})

      end
    end
    errored_value = ""
    ret = {:errored_ids => {}, :successful_ids => {}}
    i = 0
    begin
      k = "title"
      v = params[:id]
      if v != "" and v
        resource = create_resource( {'snippet.playlist_id': pList.id,
                                     'snippet.resource_id.kind': 'youtube#video',
                                     'snippet.resource_id.video_id': v,
                                     'snippet.position': ''}) # See full sample for function
        response = @@service.insert_playlist_item( 'snippet', resource, {})
      end 
      ret[:successful_ids][k] = v
      rescue => e  
        raise e.message  + e.backtrace.inspect 
    end
        

    render :json => ret

  end 
  
  def loadAllWatchLater
    addToPlayList = (params["title"] != "" and params["title"])

    if addToPlayList
      pList = playlistExists( params["title"])
      if pList.nil?
         resource = create_resource({'snippet.title': params["title"],
                                     'snippet.description': '',
                                     'snippet.tags[]': '',
                                     'snippet.default_language': '',
                                     'status.privacy_status': ''}) # See full sample for function
         pList = @@service.insert_playlist('snippet,status', resource, {})

      end 
    end
    if params["list"]
    errored_value = ""
    ret = {:errored_ids => {}, :successful_ids => {}}
    i = 0
      params["list"].each do |k,v|
        sleep(0.5)
        begin
          if v != "" and v
             # client.add_video_to_playlist(pList.playlist_id, v)

              resource = create_resource( {'snippet.playlist_id': pList.id,
                                           'snippet.resource_id.kind': 'youtube#video',
                                           'snippet.resource_id.video_id': v,
                                           'snippet.position': ''}) # See full sample for function
              response = @@service.insert_playlist_item( 'snippet', resource, {})


          end
          ret[:successful_ids][k] = v
          rescue => e
            raise e.message  + e.backtrace.inspect
        end
      end
    end 
    render :json => ret
  end

private
# Build a resource based on a list of properties given as key-value pairs.
  def create_resource(properties)
    resource = {}
    properties.each do |prop, value|
      ref = resource
      prop_array = prop.to_s.split(".")
      for p in 0..(prop_array.size - 1)
        is_array = false
        key = prop_array[p]
        # For properties that have array values, convert a name like
        # "snippet.tags[]" to snippet.tags, but set a flag to handle
        # the value as an array.
        if key[-2,2] == "[]"
          key = key[0...-2]
          is_array = true
        end
        if p == (prop_array.size - 1)
          if is_array
            if value == ""
              ref[key.to_sym] = []
            else
              ref[key.to_sym] = value.split(",")
            end
          elsif value != ""
            ref[key.to_sym] = value
          end
        elsif ref.include?(key.to_sym)
          ref = ref[key.to_sym]
        else
          ref[key.to_sym] = {}
          ref = ref[key.to_sym]
        end
      end
    end
    return resource
  end

  def playlistExists(title)
    t = nil
    my_channel = @@service.list_channels('snippet,contentDetails', {mine: true})

    response = @@service.list_playlists('snippet', {:channel_id => my_channel.items[0].id})
    response.items.each{|a|
      if a.snippet.title == title
        t  = a
      end
    }
    return t
  end
  
def getPlaylistTitles(name)

  playlist = playlistExists(name)
  ret = ""

  if !playlist.nil?
    response = @@service.list_playlist_items('snippet,contentDetails', { :playlist_id => playlist.id} )
    response.items.each do |a|
      ret += a.snippet.title + "\r\n"
    end
  end
  return ret

end
  
end