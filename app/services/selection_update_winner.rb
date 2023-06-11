# frozen_string_literal: true

class SelectionUpdateWinner
  def initialize(match, try_num)
    @match = match
    @try_num = try_num
  end

  def call
    selections = @match.selections.by_try_num(@try_num)
    choice1 = selections.first.choice
    choice2 = selections.last.choice
    return if choice1 == choice2

    if winning_combination?(choice1, choice2)
      selections.first.update(winner: true)
    else
      selections.last.update(winner: true)
    end
  end

  private

  def winning_combination?(choice1, choice2)
    combinations = [%w[rock scissor], %w[scissor paper], %w[paper rock]]
    combinations.include?([choice1, choice2])
  end
end
