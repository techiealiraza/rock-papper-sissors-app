class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update destroy]

  # GET /matches or /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1 or /matches/1.json
  def show; end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit; end

  # POST /matches or /matches.json
  def create
    # tournament = Tournament.find(tournament_id)
    # registered_users = tournament.users
    # registered_users.combination(2).each do |user1, user2|
    #   match = Match.new(tournament:))
    # match.users << user1
    # match.users << user2
    # match.save
    # end

    tournament = Tournament.find(tournament_id)
    registered_users = tournament.users.shuffle

    matches = []

    registered_users.each_slice(2) do |pair|
      match = Match.new(tournament_id: tournament.id)
      match.users << pair
      matches << match
    end

    registered_users.each_slice(3) do |trio|
      match = Match.new(tournament_id: tournament.id)
      match.users << trio
      matches << match
    end

    registered_users.each_slice(4) do |quad|
      match = Match.new(tournament_id: tournament.id)
      match.users << quad
      matches << match
    end

    Match.transaction do
      matches.each(&:save!)
    end

    respond_to do |format|
      if @match.save
        format.html { redirect_to match_url(@match), notice: 'Match was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to match_url(@match), notice: 'Match was successfully updated.' }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy
    @match.destroy

    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_match
    @match = Match.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def match_params
    params.require(:match).permit(:match_winner_id, :winner_score, :match_time, :tournament_id)
  end
end
