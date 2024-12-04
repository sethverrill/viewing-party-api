class MovieSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :vote_average

  def initialize(movie_data)
    @movie_data = movie_data
  end

  def serializable_hash
    @movie_data.map do |movie|
      {
        id: movie[:id].to_s,
        type: 'movie',
        attributes: {
          title: movie[:title],
          vote_average: movie[:vote_average]
        }
      }
    end
  end
end