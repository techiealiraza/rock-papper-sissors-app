# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action authenticate_user!
  def index
    @messages = Message.all
  end

  def show
    @match = Match.find(params[:id])
    @matchmessage = @match.messages
  end

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
    @message = Message.new(user_id:, match_id:, message:)

    if @message.save
      head :no_content
      broadcast_message(@message)
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

  def broadcast_message(message)
    user = User.where(id: message.user_id)
    user_name = user[0].name
    payload = {
      message: message.message,
      user_name:,
      created_at: (message.created_at + 5.hours).strftime('%H:%M:%S')
    }
    # byebug
    ActionCable.server.broadcast("room_channel_#{message.match_id}", payload)
  end

  # Use callbacks to share common setup or constraints between actions.

  # Only allow a list of trusted parameters through.
  # def message_params
  #   # byebug
  #   params.require(:message).permit(:user_id, :match_id).tap do |message_params|
  #     message_params[:message] = { body: params[:message] }
  #   end
  # end
end
