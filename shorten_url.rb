require_relative 'url'

class ShortenUrl
  attr_accessor :url, :shortcode

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(attrs)
    @url = attrs[:url]
    @shortcode = attrs[:shortcode]
  end

  def execute
    record = if shortcode.nil?
               create_unique_record
             else
               Url.create(url: sanitize(url), shortcode: shortcode)
             end
    if record.valid?
      OpenStruct.new(success?: true, shortcode: record.shortcode, errors: nil)
    else
      OpenStruct.new(success?: false, shortcode: nil, errors: record.errors)
    end
  end

  private

  def create_unique_record
    unique_shortcode = Url.generate_unique_shortcode
    Url.create(url: sanitize(url), shortcode: unique_shortcode)
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def sanitize(original_url)
    return if original_url.nil?

    original_url.strip!
    original_url = original_url.downcase.gsub(%r{(https?:\/\/)|(www\.)}, '')
    original_url.slice!(-1) if original_url[-1] == '/'
    "http://#{original_url}"
  end
end
