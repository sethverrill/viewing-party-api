class TmdbService
  URL = "https://api.themoviedb.org/3"

  def self.connection
    api_key = Rails.application.credentials.dig(:tmdb, :api_read_access_token)

    Faraday.new(url: URL) do |f|
      f.headers['Authorization'] = "Bearer #{api_key}"
      f.headers['accept'] = 'application/json'
    end
  end

  def self.get_top_rated_movies
    response = connection.get("movie/top_rated?language=en-US&page=1")
    parse_response(response)[:results]
  end

  def self.search_movies(query)
    response = connection.get("search/movie", { query: query, language: 'en-US', include_adult: false, page: 1 })
    parse_response(response)[:results]
  end

  def self.get_movie(movie_id)
    movie = connection.get("movie/#{movie_id}?language=en-US")
    credits = connection.get("movie/#{movie_id}/credits")
    reviews = connection.get("movie/#{movie_id}/reviews")

    {
      movie: parse_response(movie),
      credits: parse_response(credits),
      reviews: parse_response(reviews)
    }
  end

  private

  def self.parse_response(response)
    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    else
      nil
    end
  end
end
