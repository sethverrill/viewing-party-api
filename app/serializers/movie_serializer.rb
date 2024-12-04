class MovieSerializer
  include JSONAPI::Serializer
  attributes :title, :vote_average

  def id 
    object.id.to_s
  end
end