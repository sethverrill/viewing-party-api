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

  def patch
    viewing_party = find_viewing_party
    return unless viewing_party

    invitee = find_invitee
    return unless invitee

    if already_invited?(viewing_party, invitee)
      render_error("User is already part of the viewing party", :unprocessable_entity)
      return
    end

    add_invitee_to_party(viewing_party, invitee)
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end

  def find_viewing_party
    viewing_party = ViewingParty.find_by(id: params[:id])
    return render_not_found("Viewing party") unless viewing_party

    viewing_party
  end

  def find_invitee
    user = User.find_by(id: params[:invitees_user_id])
    return render_not_found("User") unless user

    user
  end

  def already_invited?(viewing_party, invitee)
    viewing_party.users.include?(invitee)
  end

  def add_invitee_to_party(viewing_party, invitee)
    viewing_party.users << invitee
    render json: ViewingPartySerializer.new(viewing_party).serializable_hash.to_json, status: :ok
  end

  def render_not_found(resource)
    render json: { error: "#{resource} not found" }, status: :not_found
    return
  end

  def render_error(message, status)
    render json: { error: message }, status: status
    return
  end
end
