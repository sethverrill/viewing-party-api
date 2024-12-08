class ViewingPartyUserService
  
  def self.create_users_for_party(viewing_party, invitees, host_id)
    invitees.each do |invitee_id|
      is_host = (invitee_id.to_s == host_id.to_s)
      ViewingPartyUser.create(viewing_party: viewing_party, user_id: invitee_id, host: is_host)
    end
  end
end