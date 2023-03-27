class TournamentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tournament, only: %i[show edit update destroy]

  # GET /tournaments or /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1 or /tournaments/1.json
  def show; end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit; end

  def registration
    @tournament = Tournament.find(params[:tournament_id])
    @user = User.find(params[:user_id])
    # @tournaments_user = @tournament.tournaments_user.build(user_id: current_user.id)
    @tournaments_user = TournamentsUser.new(user: @user, tournament: @tournament)
    if @tournaments_user.save
      flash[:success] = 'You have registered for the tournament!'
      redirect_to tournament_url(@tournament)
    else
      flash[:error] = 'Registration failed.'
      redirect_to tournament_url(@tournament)
    end
  end

  # POST /tournaments or /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to tournament_url(@tournament), notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to tournament_url(@tournament), notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1 or /tournaments/1.json
  def destroy
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tournament_params
    params.require(:tournament).permit(:name, :description, :start_date, :end_date, :tournament_winner_id)
  end
end
