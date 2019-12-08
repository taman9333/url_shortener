require 'sinatra/activerecord'

class Url < ActiveRecord::Base
  CHARSETS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + ['_']

  validates :url, presence: true
  validates :shortcode, presence: true, uniqueness: true,
                        format: { with: /\A[0-9a-zA-Z_]{4,}\z/i }

  def self.generate_unique_shortcode
    unique_shortcode = nil
    loop do
      unique_shortcode = 6.times.map { CHARSETS.sample }.join
      break if Url.find_by_shortcode(unique_shortcode).nil?
    end
    unique_shortcode
  end
end
