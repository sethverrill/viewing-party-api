FactoryBot.define do
  factory :viewing_party do
    name { "My Movie Party" }
    start_time { 1.day.from_now }
    end_time { 1.day.from_now + 2.hours }  
    association :movie
    movie_title { movie.title }  
    host_id { create(:user).id }
  end
end
