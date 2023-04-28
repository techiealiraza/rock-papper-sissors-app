class SelectionController < ApplicationController
  ROCK = 'rock'
  PAPER = 'paper'
  SCISSOR = 'scissor'
  after_action :result, only: %i[create]
  def create
    @selection = Selection.new(selection_params)
    @match = Match.where(id: params[:selection][:match_id])
    @done_tries = Selection.where(match_id: params[:selection][:match_id], user: params[:selection][:user])
    @done_tries_length = @done_tries.length
    # byebug
    @selection.try_num = @match[0].tries - (@match[0].tries - @done_tries_length)

    respond_to do |format|
      if @selection.save
        format.json { render json: { data: 'Saved' }, status: :ok }
      else
        format.json { render json: { errors: @selection.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def new
    @selection = Selection.new
  end

  def index
    @selections = Selection.findByMatchAndUser(params[:match_id], params[:user_id])
  end

  def result
    # byebug
    sleep(2)
    @match = Match.find(params[:selection][:match_id])
    @players = @match.users.pluck(:id)
    current_user_index = @players.index(current_user.id)
    opponent_user_index = if current_user_index == 0
                            1
                          else
                            0
                          end
    current_user = @players[current_user_index]
    opponent_user = @players[opponent_user_index]
    @current_user_selections = Selection.where(match_id: @match.id, user: current_user).order('try_num')
    @opponent_user_selections = Selection.where(match_id: @match.id, user: opponent_user).order('try_num')
    return if @current_user_selections.empty? && @opponent_user_selections.empty?

    # if @opponent_user_selections.empty?
    #   last = @current_user_selections.last
    #   last.winner = true
    #   last.save
    #   return
    # end

    @current_user_latest_selection = @current_user_selections.last
    # if @opponent_user_selections.empty?
    #   @current_user_latest_selection.winner = true
    #   @current_user_latest_selection.save
    # else
    @opponent_user_latest_selection = @opponent_user_selections.last
    return unless !@current_user_selections.nil? || !@opponent_user_latest_selection.nil?

    check_winner(@current_user_latest_selection, @opponent_user_latest_selection)

    # end
  end

  def check_winner(player1, player2)
    # if player1.size == player2.size
    selection1 = player1.selection
    if player2.nil?
      player1.winner = true
      player1.save
      return
    end
    selection2 = player2.selection
    # byebug
    return if selection1 == selection2

    if (selection1 == 'rock' && selection2 == 'scissor') ||
       (selection1 == 'scissor' && selection2 == 'paper') ||
       (selection1 == 'paper' && selection2 == 'rock')
      player1.winner = true
      player1.save
    elsif (selection2 == 'rock' && selection1 == 'scissor') ||
          (selection2 == 'scissor' && selection1 == 'paper') ||
          (selection2 == 'paper' && selection1 == 'rock')
      player2.winner = true
      player2.save
    end
  end

  private

  def selection_params
    # byebug
    params.require(:selection).permit(:match_id, :user, :selection)
  end
end
