class Dice
  attr_reader :amount

  def initialize
    @amount = 6
  end

  def roll
    rand(1..@amount)
  end
end
