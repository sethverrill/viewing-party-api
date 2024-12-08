class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key
  has_many :viewing_party_users
  has_many :hosted_parties, -> { ViewingPartyUser.hosts }, through: :viewing_party_users, source: :viewing_party
  has_many :invited_parties, -> { ViewingPartyUser.invitees }, through: :viewing_party_users, source: :viewing_party
end