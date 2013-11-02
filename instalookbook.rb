require 'sinatra'
require 'haml'
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

get '/lookbook' do
  # collect bonobos images from instagram API
  images = {}
  Instagram.user_recent_media('8194723', count: 100).select{|m| m['type'] == 'image' }.map do |media|
    images["img-#{media['id']}"] = {
      thumb: media['images']['thumbnail']['url'],
      large: media['images']['standard_resolution']['url']
    }
  end

  haml :lookbook, layout: :application, locals: { images: images }
end

get '/oauth/callback' do
  response = Instagram.get_access_token(params[:code], redirect_uri: CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect '/lookbook'
end

get '/oauth/connect' do
  redirect Instagram.authorize_url(redirect_uri: CALLBACK_URL)
end