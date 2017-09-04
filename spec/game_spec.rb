require_relative "spec_helper"

require_relative "../src/game"
require_relative "../src/player"

describe Game do
  let(:game) do
    Game.new([
      Player.new("Player 1"),
      Player.new("Player 2")
    ])
  end

  describe "rolling non doubles should change current player" do
    current_player = @game.current_player

    @game.send(:set_current_player, [1, 2])

    expect(current_player).to change
  end
end
