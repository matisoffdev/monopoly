class FreeParking
  attr_reader :position, :name, :purchased

  def initialize
    @position = 20
    @name = "Free Parking"
    @purchased = nil
  end

  def process(game, rolled = [])
    puts "#{game.current_player.name} landed on Free Parking! He won the pot of $#{game.pot}"
    game.current_player.cash += game.pot
    game.pot = 0
  end
end
