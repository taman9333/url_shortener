require 'sinatra'
require 'json'
require_relative 'shorten_url'

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

get '/:shortcode' do
  record = Url.find_by_shortcode(params[:shortcode])
  if record.present?
    record.update_count!
    [302, { 'location' => record.url }, {}]
  else
    [404, { error: 'The shortcode cannot be found in the system' }.to_json]
  end
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

get '/:shortcode/stats' do
  record = Url.find_by_shortcode(params[:shortcode])
  if record.present?
    [200, { startDate: record.created_at.iso8601,
            redirectCount: record.redirect_count,
            lastSeenDate: record.last_seen_date&.iso8601
          }.to_json]
  else
    [404, { error: 'The shortcode cannot be found in the system' }.to_json]
  end
end