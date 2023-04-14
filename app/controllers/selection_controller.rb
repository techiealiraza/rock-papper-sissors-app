class SelectionController < ApplicationController
  ROCK = 'rock'
  PAPER = 'paper'
  SCISSOR = 'scissor'
  def create
    @selection = Selection.new(selection_params)

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

  def update_winner(selection1, selection2)
    if selection1.selection == selection2.selection
    # format.html { render match_playmatch_path(match), notice: 'tie' }
    elsif (selection1.selection == ROCK && selection2.selection == SCISSOR) ||
          (selection1.selection == SCISSOR && selection2.selection == PAPER) ||
          (selection1.selection == PAPER && selection2.selection == ROCK)
      puts "#{player1['played']} wins!"
    else
      puts "#{player2['played']} wins!"
    end
  end

  private

  def selection_params
    # byebug
    params.require(:selection).permit(:match_id, :user, :selection)
  end
end
