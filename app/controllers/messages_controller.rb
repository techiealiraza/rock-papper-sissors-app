# frozen_string_literal: true

class MessagesController < ApplicationController
  load_and_authorize_resource
  def index
    @messages = Message.all
  end

  # GET /tournaments/new
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.save
        format.json { render json: { data: 'Saved' }, status: :ok }
        broadcast_message(@message)
      else
        format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.permit(:user_id, :match_id, :message)
  end

  def broadcast_message(message)
    payload = {
      message: message.message,
      user_name: message.user_name,
      created_at: (message.created_at + 5.hours).strftime('%H:%M:%S')
    }
    ActionCable.server.broadcast("room_channel_#{message.match_id}", payload)
  end
end
