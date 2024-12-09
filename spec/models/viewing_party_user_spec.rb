require 'rails_helper'

RSpec.describe ViewingPartyUser, type: :model do
  let(:host) {  User.find_or_create_by!(name: "Danny DeVito", username: "danny_de_v") do |user|
    user.password = "jerseyMikesRox7"
  end
  }
  let(:invitee) { User.find_or_create_by!(name: "Dolly Parton", username: "dollyP") do |user|
    user.password ="Jolene123"
  end
  }
  let(:viewing_party) do
    ViewingParty.create!(
      name: "Movie Night",
      start_time: Time.now,
      end_time: Time.now + 2.hours,
      movie_id: 101,
      movie_title: "The Prestige",
      host_id: host.id
    )
  end

  describe 'Associations' do
    it { should belong_to(:viewing_party) }
    it { should belong_to(:user) }
  end

  describe 'Scopes' do
    let!(:host_user) { ViewingPartyUser.create!(viewing_party: viewing_party, user: host, host: true) }
    let!(:invitee_user) { ViewingPartyUser.create!(viewing_party: viewing_party, user: invitee, host: false) }

    it 'returns only hosts' do
      expect(ViewingPartyUser.hosts).to include(host_user)
      expect(ViewingPartyUser.hosts).not_to include(invitee_user)
    end

    it 'returns only invitees' do
      expect(ViewingPartyUser.invitees).to include(invitee_user)
      expect(ViewingPartyUser.invitees).not_to include(host_user)
    end
  end

  describe "Password security" do
    it "stores the password securely for the host" do
      expect(host.authenticate("jerseyMikesRox7")).to eq(host)
      expect(host.password_digest).not_to eq("jerseyMikesRox7")
    end
  
    it "stores the password securely for the invitee" do
      expect(invitee.authenticate("Jolene123")).to eq(invitee)
      expect(invitee.password_digest).not_to eq("Jolene123")
    end
  
    it "does not authenticate with an incorrect password for the host" do
      expect(host.authenticate("wrongPassword")).to be_falsey
    end
  
    it "does not authenticate with an incorrect password for the invitee" do
      expect(invitee.authenticate("wrongPassword")).to be_falsey
    end
  end
end