class GoToJail
  attr_reader :position, :name, :purchased

  def initialize
    @position = 30
    @name = "Go to Jail"
    @purchased = nil
  end

  def process(game, rolled = [])
    game.current_player.position = 10
    game.current_player.jail[:in_jail] = true
  end
end
