require 'sinatra/activerecord'

class Url < ActiveRecord::Base
  validates :url, presence: true
  validates :shortcode, presence: true, uniqueness: true,
                        format: { with: /\A[0-9a-zA-Z_]{4,}\z/i }
end