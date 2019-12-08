require 'sinatra/activerecord'

class Url < ActiveRecord::Base
  CHARSETS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + ['_']

  validates :url, presence: true
  validates :shortcode, presence: true, uniqueness: true,
                        format: { with: /\A[0-9a-zA-Z_]{4,}\z/i }

  # update counter with locking record to handle race condition
  def update_count!
    with_lock do
      self.redirect_count += 1
      self.last_seen_date = Time.now
      save!
    end
  end

  def self.generate_unique_shortcode
    unique_shortcode = nil
    loop do
      unique_shortcode = 6.times.map { CHARSETS.sample }.join
      break if Url.find_by_shortcode(unique_shortcode).nil?
    end
    unique_shortcode
  end
end
