FactoryBot.define do
  factory :movie do
    title { "Cool Hand Luke" }
    vote_average { 8.5 }
    tmdb_id { rand(1000..9999) }
  end
end
