require 'rubygems'
require 'sinatra'
require 'erb'
require 'dm-core'

DOMAIN = 'example.com'
WEBFINGER_SERVER = 'http://webfinger.' + DOMAIN

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://root:@localhost/webfinger')
class Webfinger
  include DataMapper::Resource
  property  :id,    Serial
  property  :email, String, :length => 255
  property  :finger,   Text
end

# Automatically create the tables if they don't exist.
# DataMapper.auto_migrate!

get '/' do
  erb :hello
end

get '/.well-known/host-meta' do
  erb :hostmeta
end

get '/webfinger/:uri' do
  result = Webfinger.first(:email => params[:uri])
  @result = result.finger if result
  erb :webfinger
end