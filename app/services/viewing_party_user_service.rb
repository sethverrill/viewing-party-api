class ViewingPartyUserService
  def self.create_users_for_party(viewing_party, invitees, host_id)
    ViewingPartyUser.create!(
      viewing_party: viewing_party,
      user_id: host_id,
      host: true
    )

    invitees.each do |invitee_id|
      ViewingPartyUser.create!(
        viewing_party: viewing_party,
        user_id: invitee_id,
        host: false
      )
    end
  end
end
