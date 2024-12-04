require "rails_helper"

RSpec.describe "Movies Endpoint" do
  describe "happy path" do
    it "can retrieve the top 20 most popular movies" do
      VCR.use_cassette("top_20_movies") do    
        get "/api/v1/movies"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(json).to be_an(Array)
        expect(json.size).to be <= 20
        expect(json.first).to have_key(:id)
        expect(json.first).to have_key(:type)
        expect(json.first[:attributes]).to have_key(:title)
        expect(json.first[:attributes]).to have_key(:vote_average)
      end
    end

    it "has a functioning search" do
      VCR.use_cassette("lotr_search") do
        get "/api/v1/movies", params: { query: 'Lord of the Rings' }
        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(json).to be_an(Array)
        expect(json.size).to be <= 20

        json.each do |movie|
          expect(movie).to have_key(:id)
          expect(movie[:attributes]).to have_key(:title)
          expect(movie[:attributes]).to have_key(:vote_average)
        end
      end
    end
  end
end