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

    it "returns a 400 error" do
      allow(TmdbService).to receive(:get_top_rated_movies).and_return(nil)
      
      get "/api/v1/movies"
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({ "error" => "Failed to fetch movies" })
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

    it "returns a 400 error with a failure message" do
      allow(TmdbService).to receive(:search_movies).with("unknown_movie").and_return(nil)

      get "/api/v1/movies", params: { query: "unknown_movie" }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({ "error" => "Failed to fetch movies" })
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

    it "returns a 404 error with a not found message" do
      allow(TmdbService).to receive(:get_movie).with("12345").and_return({ movie: nil })

      get "/api/v1/movies/12345"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({ "error" => "Movie not found" })
    end

    it "returns only the movie data without details" do
      movie_data = { movie: { id: 1, title: "Test Movie" }, credits: {}, reviews: {} }
      allow(TmdbService).to receive(:get_movie).with("1").and_return(movie_data)

      get "/api/v1/movies/1", params: { details: "invalid" }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      movie = json_response["data"].first
      expect(movie["attributes"]["title"]).to eq("Test Movie")
      expect(movie["attributes"]).not_to have_key("credits")
      expect(movie["attributes"]).not_to have_key("reviews")
    end
  end
end