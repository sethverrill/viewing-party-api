class MovieSerializer
  include JSONAPI::Serializer

  def initialize(movie_data, details: false)
    @movies = Array.wrap(movie_data)
    @details = details
  end

  def serializable_hash
    single_movie = @movies.first
    {
      data: @movies.map { |movie| serialize_movie(movie) }
    }
  end

  private

  def serialize_movie(movie)
    {
      id: movie[:id].to_s,
      type: 'movie',
      attributes: @details ? detailed_attributes(movie) : basic_attributes(movie)
    }
  end

  def basic_attributes(movie)
    {
      title: movie[:title],
      vote_average: movie[:vote_average]
    }
  end

  def detailed_attributes(movie)
    {
      title: movie[:title],
      vote_average: movie[:vote_average],
      release_year: movie[:release_date] ? Date.parse(movie[:release_date]).year : nil,
      runtime: runtime(movie[:runtime]),
      genres: genres(movie[:genres]),
      summary: movie[:overview],
      cast: cast(movie),
      total_reviews: movie.dig(:reviews, :total_results) || 0,
      reviews: reviews(movie)
    }
  end

  def runtime(runtime_value)
    hours = runtime_value / 60
    minutes = runtime_value % 60
    "#{hours} hours, #{minutes} minutes"
  end

  def release_year(release_date)
    Date.parse(release_date).year
  end

  def genres(genres_array)
    genres_array&.map { |genre| genre[:name] }
  end

  def cast(movie)
    movie.dig(:credits, :cast)&.first(10)&.map do |member|
      { character: member[:character], actor: member[:name] }
    end
  end

  def reviews(movie)
    movie.dig(:reviews, :results)&.first(5)&.map do |review|
      { author: review[:author], review: review[:content] }
    end
  end
end
