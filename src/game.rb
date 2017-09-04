require_relative "board"
require_relative "dice"

class Game
  attr_reader :players, :board, :dice, :current_player

  attr_accessor :pot

  AMOUNT_OF_BOARD_SPOTS = 39

  def initialize(players)
    @players = players

    @board = Board.new

    @dice = [
      Dice.new,
      Dice.new
    ]

    @current_player = @players.first

    @pot = 0
  end

  def roll
    puts "Roll, Buy houses, or Mortgage property? (r/b/m)"
    action = gets.chomp

    return roll if !["r", "b", "m"].include?(action)

    if action == "r"
      # roll each dice and put results into array
      rolled = roll_dice

      unless in_jail?(rolled)
        set_new_position(rolled)
      else
        @current_player.jail[:rolls] += 1
      end

      current_square = @board.squares[@current_player.position]

      puts "#{@current_player.name} rolled a #{rolled[0]} and #{rolled[1]} and is on #{current_square.name}.\n"

      current_square.process(self, rolled)

      set_current_player(rolled)
    elsif action == "b"

    elsif action == "m"

    end
  end

  private

  def in_jail?(rolled = [])
    in_jail = @current_player.jail[:in_jail] == true
    under_roll_limit = @current_player.jail[:rolls] < 3

    in_jail && under_roll_limit && rolled[0] != rolled[1]
  end

  def position_name(player)
    @board.position(@current_player.position).name
  end

  def set_new_position(rolled)
    if @current_player.position + sum(rolled) > AMOUNT_OF_BOARD_SPOTS
      puts "#{@current_player.name} passed Go and collects $200!"
      @current_player.cash += 200
      @current_player.position = @current_player.position + sum(rolled) - AMOUNT_OF_BOARD_SPOTS - 1
    else
      @current_player.position += sum(rolled)
    end
  end

  def set_current_player(rolled)
    current_player_index = @players.index(@current_player)

    @current_player.current_rolls += 1

    if rolled[0] == rolled[1] && @current_player.current_rolls < 3
      return
    elsif @current_player.current_rolls >= 3
      @current_player.send_to_jail
    end

    @current_player.current_rolls = 0

    if @current_player == @players.last
      @current_player = @players.first
    else
      @current_player = @players[current_player_index + 1]
    end
  end

  def roll_dice
    @dice.map do |dice|
      dice.roll
    end
  end

  def sum(rolled)
    rolled.inject(0, :+)
  end
end
