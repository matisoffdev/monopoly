require_relative "purchasable_square"

class Railroad < PurchasableSquare
  attr_accessor :name, :purchased, :owner
  attr_reader :purchase_price

  def initialize(options)
    @name = options[:name]
    @purchased = false
    @owner = nil
    @purchase_price = 200
  end

  def process(game, rolled = [])
    if @purchased == true && game.current_player != @owner
      puts "#{game.current_player.name} paid #{@owner.name} $#{rent}"
      game.current_player.cash -= rent
      @owner.cash += rent
    elsif @purchased == false
      puts "Would you like to purchase this property? (y/n)"
      wants_to_purchase = gets.chomp

      if wants_to_purchase == "y" && player_can_afford?(game.current_player)
        @purchased = true
        @owner = game.current_player
        game.current_player.owned_properties.push(self)
        game.current_player.cash -= @purchase_price
        puts "#{game.current_player.name} purchased #{@name}, and has $#{game.current_player.cash} left."
      end
    end
  end

  private

  def rent
    railroads_owned = owner.owned_properties.select do |owned|
      owned.is_a?(Railroad)
    end

    rent = {
      0 => 0,
      1 => 25,
      2 => 50,
      3 => 100,
      4 => 200
    }

    rent[railroads_owned.count]
  end
end
