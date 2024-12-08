class Api::V1::MoviesController < ApplicationController
  def index
    query = params[:query]
    response = if query.present?
                TmdbService.search_movies(query)
              else
                TmdbService.get_top_rated_movies
              end

    if response
      render json: MovieSerializer.new(response).serializable_hash.to_json
    else
      render json: { error: "Failed to fetch movies" }, status: :bad_request
    end
  end

  def show
    movie_data = TmdbService.get_movie(params[:id])
    if movie_data
      render json: MovieSerializer.new(movie_data).serializable_hash.to_json, status: :ok
    else
      render json: { error: "Movie not found" }, status: :not_found
    end
  end
end
