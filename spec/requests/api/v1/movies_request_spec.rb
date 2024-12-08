require "rails_helper"

RSpec.describe "Movies Endpoint" do
  describe "index" do
    it "can retrieve the top 20 most popular movies" do
      VCR.use_cassette("top_20_movies") do    
        get "/api/v1/movies"
  
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(json).to be_an(Array)
        expect(json.size).to be <= 20
        expect(json.first).to have_key(:id)
        expect(json.first[:attributes]).to have_key(:title)
        expect(json.first[:attributes]).to have_key(:vote_average)
      end
    end

    it "does a search" do
      VCR.use_cassette("lotr_search") do
        get "/api/v1/movies", params: { query: 'Lord of the Rings' }
        
        expect(response).to have_http_status(:ok)
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

  describe "show" do
    it "retrieves detailed information about the movie 'Cool Hand Luke'" do
      VCR.use_cassette("cool_hand_luke_details") do
        get "/api/v1/movies/903", params: { details: "true" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)[:data]
    
        expect(json.first[:id]).to eq("903")
        expect(json.first[:attributes][:title]).to eq("Cool Hand Luke")
        expect(json.first[:attributes][:release_year]).to eq(1967)
      end
    end
  end
end