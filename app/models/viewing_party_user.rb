class ViewingPartyUser < ApplicationRecord
  belongs_to :viewing_party
  belongs_to :user

  scope :hosts, -> { where(host: true) }
  scope :invitees, -> { where(host: false) }
end