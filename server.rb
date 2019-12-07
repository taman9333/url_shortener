require 'sinatra'
require 'json'
require_relative 'shorten_url'
require 'byebug'

before do
  content_type 'application/json'
end

before '/shorten' do
  begin
    valid_params = ['url', 'shortcode']
    permitted_params = JSON.parse(request.body.read).select { |k, _v| valid_params.include? k }
    @job_params = Sinatra::IndifferentHash[permitted_params]
  rescue JSON::ParserError
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end

get '/' do
  { msg: 'hello world' }.to_json
end

post '/shorten' do
  result = ShortenUrl.call(@job_params)
  if result.success?
    [201, { shortcode: result.shortcode }.to_json]
  elsif result.errors.added? :shortcode, 'has already been taken'
    [409, { errors: result.errors.full_messages }.to_json]
  elsif result.errors.added? :url, :blank
    [400, { errors: result.errors.full_messages }.to_json]
  else
    [422, { errors: result.errors.full_messages }.to_json]
  end
end