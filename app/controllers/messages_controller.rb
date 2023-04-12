class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show; end

  # GET /tournaments/new
  def new
    @message = Message.new
  end

  # GET /tournaments/1/edit
  def edit; end

  def create
    # @message = current_user.messages.build(message_params)
    user_id = params[:user_id]
    match_id = params[:match_id]
    message = params[:message]
    byebug
    @message = Message.new(user_id:, match_id:, message:)

    if @message.save
      ActionCable.server.broadcast "match_chat_#{params[:match_id]}", message: render_message(@message)
      head :ok
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  # def update
  #   respond_to do |format|
  #     if @message.update(message_params)
  #       format.html { redirect_to message_url(@message), notice: 'Message was successfully updated.' }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /tournaments/1 or /tournaments/1.json
  # def destroy
  #   @tournament.destroy

  #   respond_to do |format|
  #     format.html { redirect_to messages_url, notice: 'Message was successfully deleted.' }
  #   end
  # end

  private

  def render_message(message)
    ApplicationController.render('matches/match_messages', locals: { message: })
  end

  # Use callbacks to share common setup or constraints between actions.

  # Only allow a list of trusted parameters through.
  def message_params
    byebug
    params.require(:message).permit(:user_id, :match_id).tap do |message_params|
      message_params[:message] = { body: params[:message] }
    end
  end
end
