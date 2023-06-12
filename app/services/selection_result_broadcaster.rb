# frozen_string_literal: true

# selection_result_broadcast_service
class SelectionResultBroadcaster < Broadcaster
  def initialize(status, selections)
    @status = status
    @match = selections.first.match
    @user1_id, @user2_id = selections.pluck(:user_id).first(2)
    @choice1, @choice2 = selections.pluck(:choice).first(2)
    @data = data_hash
    super("match_channel_#{@match.id}", @match.done? ? @data.merge!(done: true) : @data)
  end

  private

  def data_hash
    {
      status: @status,
      user1_id: @user1_id,
      user2_id: @user2_id,
      choice1: @choice1,
      choice2: @choice2
    }
  end
end
