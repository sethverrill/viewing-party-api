class Api::V1::ViewingPartiesController < ApplicationController
  def create
    movie_data = TmdbService.get_movie(params[:viewing_party][:movie_id])
    if movie_data.nil? || movie_data[:title] != params[:viewing_party][:movie_title]
      render json: { error: "Invalid movie information" }, status: :unprocessable_entity
      return
    end

    viewing_party = ViewingParty.new(viewing_party_params.merge(host_id: params[:viewing_party][:host_id]))

    if viewing_party.save
      ViewingPartyUserService.create_users_for_party(viewing_party, params[:invitees], params[:viewing_party][:host_id])
      render json: ViewingPartySerializer.new(viewing_party).serializable_hash.to_json, status: :created
    else
      render json: { error: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end
end
