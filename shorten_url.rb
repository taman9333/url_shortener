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
    record = Url.create(url: url, shortcode: shortcode)
    if record.valid?
      OpenStruct.new(success?: true, shortcode: record.shortcode, errors: nil)
    else
      OpenStruct.new(success?: false, shortcode: nil, errors: record.errors)
    end
  end

end
