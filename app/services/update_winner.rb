class UpdateWinner
  def initialize(match, try_num)
    @match = match
    @try_num = try_num
  end

  def update_winner
    selections = @match.selections.where(try_num: @try_num)
    choice1, choice2 = selections.pluck(:selection).first(2)
    return if choice1 == choice2

    if winning_combination?(choice1, choice2)
      selections.first.update(winner: true)
    else
      selections.last.update(winner: true)
    end
  end

  def winning_combination?(choice1, choice2)
    combinations = [%w[rock scissor], %w[scissor paper], %w[paper rock]]
    combinations.include?([choice1, choice2])
  end
end
