# frozen_string_literal: true

class MessagesController < ApplicationController
  load_and_authorize_resource
  def index
    @messages = Message.all
  end

  def show
    # @match = Match.find(params[:id])
    @matchmessage = @match.messages
  end

  # GET /tournaments/new
  def new
    @message = Message.new
  end

  # GET /tournaments/1/edit
  def edit; end

  def create
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
end
