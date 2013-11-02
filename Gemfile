LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

if RUBY_VERSION =~ /1.9|2.0/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

ruby '2.0.0'

source 'https://rubygems.org'
gem 'haml'
gem 'instagram'
gem 'sinatra'

group :development, :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'pry'
end
