class LuxuryTax
  attr_reader :position, :name, :purchased

  def initialize
    @position = 38
    @name = "Luxury Tax"
    @purchased = nil
  end

  def process(game, rolled = [])
    game.current_player.cash -= 100
    game.pot += 100
  end
end
