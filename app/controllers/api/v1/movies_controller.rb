class Api::V1::MoviesController < ApplicationController
  def index
    query = params[:query]
    response = if query.present?
                TmdbService.serach_movies(query)
              else
                TmdbService.get_top_rated_movies
              end

    if response.status == 200
      json = JSON.parse(response.body, symbolize_names: true)
      movies = json[:results].first(20)
      render json: MovieSerializer.new(movies).serializable_hash.to_json
    else
      render json: { error: "Failed to fetch movies: #{response.status}" }, status: :bad_request
    end
  end

  def show
    movie_data = TmdbService.get_movie(params[:id])
    if movie_data.nil?
      render json: { error: "Movie not found" }, status: :not_found
    else
      render json: movie_data, status: :ok
    end
  end
end
