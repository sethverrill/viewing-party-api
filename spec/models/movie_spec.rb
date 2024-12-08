require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:vote_average) }
    it { should validate_presence_of(:tmdb_id) }
  end
end
