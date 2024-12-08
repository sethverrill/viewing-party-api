class Movie < ApplicationRecord
  validates :title, :vote_average, :tmdb_id, presence: true
end
