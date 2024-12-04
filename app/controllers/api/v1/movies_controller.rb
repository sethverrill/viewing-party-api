class Api::V1::MoviesController < ApplicationController

  def index
    api = Rails.application.credentials[:tmdb][:api_key]
    conn = Faraday.new(url: "https://api.themoviedb.org/3")
    response = conn.get("/movie/top_rated", {
      api_key: api
    })

    json = JSON.parse(response.body, symbolize_names: true)
    top_20 = json[:results].first(20)

    movies = top_20.map do |movie_data|
      Movie.new(
        tmdb_id: movie_data[:id],
        title: movie_data[:title],
        vote_average: movie_data[:vote_average]
      )
    end

    render json: MovieSerializer.new(movies).serializable_hash.to_json
  end
end