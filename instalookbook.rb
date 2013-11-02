require 'sinatra'
require 'instagram'

enable :sessions, :logging

CALLBACK_URL = "http://instalookbook.herokuapp.com/oauth/callback"

Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
  config.client_secret = ENV['INSTAGRAM_CLIENT_SECRET']
end

get '/' do
  redirect '/oauth/connect'
end

get '/feed' do
  client = Instagram.client(access_token: session[:access_token])
  user = client.user

  html = "<h1>#{user.username}'s recent photos</h1>"
  for media_item in client.user_recent_media
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end

get '/lookbook' do
  haml :lookbook
end

get '/oauth/callback' do
  response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect '/lookbook'
end

get '/oauth/connect' do
  redirect Instagram.authorize_url(redirect_uri: CALLBACK_URL)
end