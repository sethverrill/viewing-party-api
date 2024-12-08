class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, movie_id, movie_title

  attribute :host_do |viewing_party|
    host_user = viewing_party.viewing_party_users.find_by(host: :true)&.user 
    {
      id: host_user.id,
      name: host_user.name
      username: host_user.username
    } if host_user
  end

  attribute :invitees do |viewing_party|
    viewing_party.viewing_party_users.where(host: false).map do |vp_invitee|
      user = vp_invitee.user
      {
        id: user.id,
        name: user.name,
        username: user.username
      }
    end
  end
end