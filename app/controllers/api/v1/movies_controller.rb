class Api::V1::MoviesController < ApplicationController
  def index
    api = Rails.application.credentials.dig(:tmdb, :api_read_access_token)
    query = params[:query]

    conn = Faraday.new(url: "https://api.themoviedb.org/3") do |f|
      f.headers['Authorization'] = "Bearer #{api}"
      f.headers['accept'] = 'application/json'
    end

    if query.present?
      response = conn.get("search/movie", {
        query: query,
        include_adult: false,
        language: 'en-US',
        page: 1
      })
    else
      response = conn.get("movie/top_rated", {
        language: 'en-US',
        page: 1
      })
    end

    if response.success?
      json = JSON.parse(response.body, symbolize_names: true)
      movies = json[:results].first(20)
      render json: MovieSerializer.new(movies).serializable_hash.to_json
    else
      render json: { error: "Failed to fetch movies: #{response.status}" }, status: :bad_request
    end
  end
end
#   before_action :tmdb_connection
#   def index
#     response = @conn.get('movie/top_rated', language: 'en-US', page: 1)

#     if response.success?
#       json = JSON.parse(response.body, symbolize_names: true)
#       movies = json[:results].first(20)
#       render json: MovieSerializer.new(movies).serializable_hash.to_json
#     else
#       render json: { error: 'Failed to fetch top-rated movies' }, status: response.status
#     end
#   end

#   def search
#     query = params[:query]

#     response = @conn.get('search/movie', {
#       query: query,
#       include_adult: false,
#       language: 'en-US',
#       page: 1
#     })

#     json = JSON.parse(response.body, symbolize_names: true)
#     movies = json[:results].first(20)
#     render json: MovieSerializer.new(movies).serializable_hash.to_json
#   end

#   private
#   def tmdb_connection
#     api = Rails.application.credentials.dig(:tmdb, :api_read_access_token)
#     @conn = Faraday.new(url: "https://api.themoviedb.org/3") do |f|
#       f.headers['Authorization'] = "Bearer #{api}"
#       f.headers['accept'] = 'application/json'
#     end
#   end
# end


