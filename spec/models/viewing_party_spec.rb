require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  before(:all) do
    @user1 = User.find_or_create_by!(name: "Danny DeVito", username: "danny_de_v") do |user|
      user.password = "jerseyMikesRox7"
    end
    @user2 = User.find_or_create_by!(name: "Dolly Parton", username: "dollyP") do |user|
      user.password = "Jolene123"
    end
    @user3 = User.find_or_create_by!(name: "Lionel Messi", username: "futbol_geek") do |user|
      user.password = "test123"
    end

    @movie = Movie.find_or_create_by!(id: 101, title: "Happy Feet", vote_average: 2.5, tmdb_id: 1234)

    @viewing_party = ViewingParty.find_or_create_by!(
      name: "Big Time Movie Party",
      start_time: Time.now + 1.day,
      end_time: Time.now + 1.day + 2.hours,
      movie_id: @movie.id,
      movie_title: @movie.title,
      host_id: @user1.id
    )

    ViewingPartyUser.find_or_create_by!(user: @user1, viewing_party: @viewing_party, host: true)
    ViewingPartyUser.find_or_create_by!(user: @user2, viewing_party: @viewing_party, host: false)
  end

  let(:user3) { @user3 }
  let(:viewing_party) { @viewing_party }

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_title) }
  end

  describe 'Associations' do
    it { should have_many(:viewing_party_users) }
    it { should have_many(:users).through(:viewing_party_users) }
    it { should have_many(:hosts).through(:viewing_party_users) }
    it { should have_many(:invitees).through(:viewing_party_users) }
  end

  describe 'one host validation' do
    it 'is a valid party with one host' do
      expect(viewing_party).to be_valid
    end

    it 'is invalid with two hosts' do
      ViewingPartyUser.create!(user: user3, viewing_party: viewing_party, host: true)
      expect(viewing_party).not_to be_valid
    end
  end
end