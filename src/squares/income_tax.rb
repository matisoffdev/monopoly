class IncomeTax
  attr_reader :name, :position, :purchased

  def initialize
    @name = "Income Tax"
    @position = 4
    @purchased = nil
  end

  def process(game, rolled = [])
    game.current_player.cash -= 200
    game.pot += 200
  end
end
