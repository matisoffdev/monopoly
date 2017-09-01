require_relative "src/player"
require_relative "src/game"

players = [Player.new("Noah"), Player.new("David")]

game = Game.new(players)

500.times do
  game.roll
end
