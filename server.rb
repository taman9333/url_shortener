require 'sinatra'
require 'json'

before do
  content_type 'application/json'
end

get '/' do
  { msg: 'hello world' }.to_json
end