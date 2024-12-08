class Api::V1::MoviesController < ApplicationController
  def index
    query = params[:query]

    movies = if query.present?
              TmdbService.search_movies(query)
            else
              TmdbService.get_top_rated_movies
            end

    if movies
      render json: MovieSerializer.new(movies).serializable_hash.to_json
    else
      render json: { error: "Failed to fetch movies" }, status: :bad_request
    end
  end

  def show
    movie_details = TmdbService.get_movie(params[:id])
    Rails.logger.debug "Movie details: #{movie_details.inspect}"

    if movie_details[:movie]
      details_requested = params[:details] == "true"
      render json: MovieSerializer.new(movie_details[:movie], details: details_requested).serializable_hash
    else
      render json: { error: "Movie not found" }, status: :not_found
    end
  end
end
