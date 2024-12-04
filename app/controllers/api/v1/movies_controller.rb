class Api::V1::MoviesController < ApplicationController
  def index
    api = Rails.application.credentials.tmdb[:api_read_access_token]
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
        include_adult: false,
        include_video: false,
        language: 'en-US',
        page: 1,
        sort_by: 'vote_average.desc'
      })
    end

    json = JSON.parse(response.body, symbolize_names: true)
    render json: MovieSerializer.new(json[:results].first(20)).serializable_hash.to_json
  end
end