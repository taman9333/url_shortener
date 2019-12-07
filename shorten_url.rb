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
    record = Url.create(url: sanitize(url), shortcode: shortcode)
    if record.valid?
      OpenStruct.new(success?: true, shortcode: record.shortcode, errors: nil)
    else
      OpenStruct.new(success?: false, shortcode: nil, errors: record.errors)
    end
  end

  private

  def sanitize(original_url)
    original_url.strip!
    original_url = original_url.downcase.gsub(%r{(https?:\/\/)|(www\.)}, '')
    original_url.slice!(-1) if original_url[-1] == '/'
    "http://#{original_url}"
  end
end
