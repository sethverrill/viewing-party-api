require 'rails_helper'

RSpec.describe "Viewing Parties Endpoints", type: :request do
  let!(:user1) { create(:user, name: "Danny DeVito") }
  let!(:user2) { create(:user, name: "Dolly Parton") }
  let!(:user3) { create(:user, name: "Lionel Messi") }
  let!(:movie) { create(:movie, title: "Cool Hand Luke", vote_average: 9.0, tmdb_id: 903) }
  let!(:viewing_party) do
    create(
      :viewing_party,
      name: "Big Time Movie Party",
      start_time: Time.now + 1.day,
      end_time: Time.now + 1.day + 2.hours,
      movie_id: movie.id,
      movie_title: movie.title,
      host_id: user1.id
    )
  end

  before do
    allow(TmdbService).to receive(:get_movie).and_return({ title: movie.title }) 
    viewing_party.users << user2
  end

  describe "POST Viewing Party" do
    context "happy path" do
      it "creates a viewing party with valid data" do
        VCR.use_cassette("viewing_party_create") do
          post "/api/v1/viewing_parties", params: {
            viewing_party: {
              name: "Cool Movie Night",
              start_time: Time.now + 2.days,
              end_time: Time.now + 2.days + 3.hours,
              movie_id: 903,
              movie_title: "Cool Hand Luke",
              host_id: user1.id
            },
            invitees: [user2.id, user3.id]
          }
  
          expect(response).to have_http_status(:created)
          data = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(data[:attributes][:name]).to eq("Cool Movie Night")
        end
      end
    end

    context "sad path" do
      it "returns an error for invalid movie data" do
        post "/api/v1/viewing_parties", params: {
          viewing_party: {
            name: "Bad Movie Party",
            start_time: Time.now + 2.days,
            end_time: Time.now + 2.days + 3.hours,
            movie_id: 9999,
            movie_title: "Invalid Movie",
            host_id: user1.id
          },
          invitees: [user2.id, user3.id]
        }

        expect(response).to have_http_status(:unprocessable_entity)
        error = JSON.parse(response.body)["error"]
        expect(error).to eq("Invalid movie information")
      end
    end
  end

  describe "PATCH Viewing Party" do
    context "happy path" do
      it "adds an invitee and returns the updated viewing party" do
        patch "/api/v1/viewing_parties/#{viewing_party.id}/patch", params: { invitees_user_id: user3.id }

        expect(response).to have_http_status(:ok)
        invitees = JSON.parse(response.body)["data"]["attributes"]["invitees"]
        expect(invitees.map { |i| i["id"] }).to include(user3.id)
      end
    end

    context "sad path" do
      it "returns a 404 error when the viewing party does not exist" do
        patch "/api/v1/viewing_parties/999/patch", params: { invitees_user_id: user3.id }

        expect(response).to have_http_status(:not_found)
        error = JSON.parse(response.body)["error"]
        expect(error).to eq("Viewing party not found")
      end

      it "returns a 404 error when the user does not exist" do
        patch "/api/v1/viewing_parties/#{viewing_party.id}/patch", params: { invitees_user_id: 999 }

        expect(response).to have_http_status(:not_found)
        error = JSON.parse(response.body)["error"]
        expect(error).to eq("User not found")
      end

      it "returns a 422 error when the user is already invited" do
        patch "/api/v1/viewing_parties/#{viewing_party.id}/patch", params: { invitees_user_id: user2.id }

        expect(response).to have_http_status(:unprocessable_entity)
        error = JSON.parse(response.body)["error"]
        expect(error).to eq("User is already part of the viewing party")
      end
    end
  end
end