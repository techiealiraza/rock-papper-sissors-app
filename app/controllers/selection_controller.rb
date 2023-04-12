class SelectionController < ApplicationController
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

  private

  def selection_params
    # byebug
    params.require(:selection).permit(:match_id, :user, :selection)
  end
end
