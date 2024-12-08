# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user1 = User.find_or_create_by!(name: "Danny DeVito", username: "danny_de_v") do |user|
  user.password = "jerseyMikesRox7"
end
user2 = User.find_or_create_by!(name: "Dolly Parton", username: "dollyP") do |user|
  user.password ="Jolene123"
end
user3 = User.find_or_create_by!(name: "Lionel Messi", username: "futbol_geek") do |user|
  user.password ="test123"
end

user4 = User.find_or_create_by!(name: "Carl Snarl", username: "cstobs") do |user|
  user.password = "italian0J0nes"
end

movie = Movie.find_or_create_by!(id: 101, title: "Happy Feet", vote_average: 2.5, tmdb_id: 1234)

viewing_party = ViewingParty.find_or_create_by!(
  name: "Big Time Movie Party",
  start_time: Time.now + 1.day,
  end_time: Time.now + 1.day + 2.hours,
  movie_id: movie.id,
  movie_title: movie.title,
  host_id: user1.id
)

ViewingPartyUser.find_or_create_by!(user: user1, viewing_party: viewing_party, host: true)
ViewingPartyUser.find_or_create_by!(user: user2, viewing_party: viewing_party, host: false)