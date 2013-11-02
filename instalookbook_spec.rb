ENV['INSTAGRAM_CLIENT_ID'] = 'a'
ENV['INSTAGRAM_CLIENT_SECRET'] = 'b'
ENV['RACK_ENV'] = 'test'

require './instalookbook'
require 'pry'
require 'rspec'
require 'rack/test'

describe 'instalookbook App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "redirects to oauth connect" do
    get '/'

    expect(last_response.header['Location']).to eq('http://example.org/oauth/connect')
  end

  it "redirects to oauth connect and then redirects to callback" do
    get '/'
    follow_redirect!

    expect(last_response.header['Location']).to eq('https://api.instagram.com/oauth/authorize/?client_id=a&redirect_uri=http%3A%2F%2Finstalookbook.herokuapp.com%2Foauth%2Fcallback&response_type=code')
  end

  it 'shows lookbook html and has image' do
    Instagram.should_receive(:user_recent_media).with('8194723', count: 100, access_token: nil).and_return(JSON.parse(File.read('./recent_media.json'))['data'])
    get '/lookbook'

    expect(last_response.body).to match(/\<title\>InstaLookBook/)
    expect(last_response.body).to match("http://distilleryimage2.s3.amazonaws.com/e06b8a12424511e3816522000a9e48f9_5.jpg")
  end
end