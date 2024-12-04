class Api::V1::MoviesController < ApplicationController
  def index
    api = Rails.application.credentials.tmdb[:api_read_access_token]

    conn = Faraday.new(url: "https://api.themoviedb.org/3") do |f|
      f.headers['Authorization'] = "Bearer #{api}"
      f.headers['accept'] = 'application/json'
    end

    response = conn.get("movie/top_rated", {
      include_adult: false,
      include_video: false,
      language: 'en-US',
      page: 1,
      sort_by: 'vote_average.desc'
    })

    json = JSON.parse(response.body, symbolize_names: true)
    top_20 = json[:results].first(20)

    movies = top_20.map do |movie_data|
      Movie.new(
        id: movie_data[:id],
        title: movie_data[:title],
        vote_average: movie_data[:vote_average]
      )
    end

    render json: MovieSerializer.new(movies).serializable_hash.to_json
  end
end