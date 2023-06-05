# frozen_string_literal: true

class MessagesController < ApplicationController
  load_and_authorize_resource
  def index; end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    respond_to do |format|
      if @message.save
        format.json { render json: { data: 'Saved' }, status: :ok }
      else
        format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.permit(:user_id, :match_id, :content)
  end
end
