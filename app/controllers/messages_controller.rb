class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show; end

  # GET /tournaments/new
  def new
    @message = message.new
  end

  # GET /tournaments/1/edit
  def edit; end

  def create
    @message = message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to message_url(@message), notice: 'message was successfully saved.' }

      else
        format.html { render :new, status: :unprocessable_entity }
      end
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

  # Use callbacks to share common setup or constraints between actions.

  # Only allow a list of trusted parameters through.
  def messgae_params
    params.require(:message).permit(:message, :user_id, :match_id)
  end
end
