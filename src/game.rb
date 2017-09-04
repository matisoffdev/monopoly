require_relative "board"
require_relative "dice"

class Game
  attr_reader :players, :board, :dice, :current_player, :pot

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

      if current_square.is_a?(Property)
        handle_property_payment(current_square)
      elsif current_square.is_a?(Railroad)
        handle_railroad_payment(current_square)
      elsif current_square.is_a?(Utility)
        handle_utility_payment(current_square, rolled)
      elsif current_square.is_a?(CommunityChest)
        draw_community_chest
      elsif current_square.is_a?(IncomeTax)
        @current_player.cash -= 200
        @pot += 200
      elsif current_square.is_a?(LuxuryTax)
        @current_player.cash -= 100
        @pot += 100
      elsif current_square.is_a?(Chance)
        draw_chance
      elsif current_square.is_a?(GoToJail)
        @current_player.position = 10
        @current_player.jail[:in_jail] = true
      elsif current_square.is_a?(FreeParking)
        puts "#{@current_player.name} landed on Free Parking! He won the pot of $#{@pot}"
        @current_player.cash += @pot
        @pot = 0
      end


      set_current_player(rolled)
    elsif action == "b"

    elsif action == "m"

    end
  end

  private

  def draw_community_chest
  end

  def draw_chance
  end

  def in_jail?(rolled = [])
    in_jail = @current_player.jail[:in_jail] == true
    under_roll_limit = @current_player.jail[:rolls] < 3

    in_jail && under_roll_limit && rolled[0] != rolled[1]
  end

  def handle_property_payment(square)
    if square.purchased == true && @current_player != square.owner
      puts "#{@current_player.name} paid #{square.owner.name} $#{square.rent}"
      @current_player.cash -= square.rent
      square.owner.cash += square.rent
    elsif square.purchased == false
      puts "Would you like to purchase this property? (y/n)"
      wants_to_purchase = gets.chomp

      if wants_to_purchase == "y" && can_afford_to_purchase?(square)
        square.purchased = true
        square.owner = @current_player
        @current_player.cash -= square.purchase_price
        puts "#{@current_player.name} purchased #{square.name}, and has $#{@current_player.cash} left."
      end
    end
  end

  def handle_railroad_payment(square)
    if square.purchased == true && @current_player != square.owner
      puts "#{@current_player.name} paid #{square.owner.name} $#{square.rent}"
      @current_player.cash -= square.rent
      square.owner.cash += square.rent
    elsif square.purchased == false
      puts "Would you like to purchase this property? (y/n)"
      wants_to_purchase = gets.chomp

      if wants_to_purchase == "y" && can_afford_to_purchase?(square)
        square.purchased = true
        square.owner = @current_player
        @current_player.owned_properties.push(square)
        @current_player.cash -= square.purchase_price
        puts "#{@current_player.name} purchased #{square.name}, and has $#{@current_player.cash} left."
      end
    end
  end

  def handle_utility_payment(square, rolled)
    if square.purchased == true && @current_player != square.owner
      puts "#{@current_player.name} paid #{square.owner.name} $#{square.rent(sum(rolled))}"
      @current_player.cash -= square.rent(sum(rolled))
      square.owner.cash += square.rent(sum(rolled))
    elsif square.purchased == false
      puts "Would you like to purchase this property? (y/n)"
      wants_to_purchase = gets.chomp

      if wants_to_purchase == "y" && can_afford_to_purchase?(square)
        square.purchased = true
        square.owner = @current_player
        @current_player.owned_properties.push(square)
        @current_player.cash -= square.purchase_price
        puts "#{@current_player.name} purchased #{square.name}, and has $#{@current_player.cash} left."
      end
    end
  end

  def can_afford_to_purchase?(square)
    @current_player.cash - square.purchase_price > 0
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
