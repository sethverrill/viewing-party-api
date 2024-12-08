class ViewingParty < ApplicationRecord
  has_many :viewing_party_users
  has_many :users, through: :viewing_party_users
  has_many :hosts, -> { where(viewing_party_users: { host: true }) }, through: :viewing_party_users, source: :user
  has_many :invitees, -> { where(viewing_party_users: { host: false }) }, through: :viewing_party_users, source: :user
  
  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true
  validate :one_host_max

  private

  def one_host_max
    if viewing_party_users.where(host: true).count > 1
      errors.add(:host, "Only one host allowed per party")
    end
  end
end