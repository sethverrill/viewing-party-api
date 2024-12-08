require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
    it { should have_secure_token(:api_key) }

    it { should have_many(:hosted_parties).class_name('ViewingParty').with_foreign_key('host_id') }
    it { should have_many(:invited_parties).through(:viewing_party_users).source(:viewing_party) }
  end
end