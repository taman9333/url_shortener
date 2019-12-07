require 'sinatra'
require 'json'
require_relative 'url'
require 'byebug'

helpers do
  def json_params
    @parsed_params ||= Sinatra::IndifferentHash[JSON.parse(request.body.read)]
  rescue JSON::ParserError
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end

before do
  content_type 'application/json'
end

get '/' do
  { msg: 'hello world' }.to_json
end

post '/shorten' do
end