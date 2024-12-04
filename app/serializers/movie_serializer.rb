class MovieSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :vote_average

  def id 
    object.tmdb_id.to_s
  end
end