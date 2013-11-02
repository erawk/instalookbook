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
    expect(last_response.header['Location']).to eq('/oauth/connect')
  end

  it "redirects to oauth connect and then redirects to callback" do
    get '/'
    follow_redirect!
    expect(last_response.header['Location']).to eq('https://api.instagram.com/oauth/authorize/?client_id=97d53ee67bbb43efa896bb38da799767&redirect_uri=http%3A%2F%2Finstalookbook.herokuapp.com%2Foauth%2Fcallback&response_type=code')
  end

  it 'shows lookbook html' do
    get '/lookbook'
    expect(last_response.body).to match(/\<title\>InstaLookBook/)
  end
end