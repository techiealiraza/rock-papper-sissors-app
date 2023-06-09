# frozen_string_literal: true

class MessagesController < ApplicationController
  load_and_authorize_resource

  def create
    @message = Message.new(message_params)
    if @message.save
      flash[:notice] = 'Message Sent'
    else
      flash[:error] = @message.errors.full_messages.join(', ')
    end
  end

  private

  def message_params
    params.permit(:user_id, :match_id, :content)
  end
end
