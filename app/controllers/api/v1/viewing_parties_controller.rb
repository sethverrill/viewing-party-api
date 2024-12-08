class Api::V1::ViewingPartiesController < ApplicationController

  def create
    missing_params = required_params.select { |param| !params.key?(param) }

    if missing_params.any?
      render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
      return
    end

    movie_data = TmdbService.get_movie(params[:movie_id])
    if movie_data.nil? || movie_data['title'] != params[:movie_title]
      render json: { error: "Invalid movie information" }, status: :unprocessable_entity
      return
    end

    viewing_party = ViewingParty.new(viewing_party_params.merge(host_id: params[:host_id]))

    if viewing_party.save 
      ViewingPartyUserService.create_users_for_party(viewing_party, params[:invitees, params[:host_id]])
      render json: ViewingPartySerializer.new(viewing_party).serializable_hash.to_json, status: :created
    else
      render json


  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end

  def required_params
    [:name, :start_time, :end_time, :movie_id, :movie_title, :invitees, :host_id]
  end
end