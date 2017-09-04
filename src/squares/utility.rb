require_relative "purchasable_square"

class Utility < PurchasableSquare
  attr_accessor :purchased, :nil, :owner

  attr_reader :position, :name, :purchase_price

  def initialize(options)
    @position = options[:position]
    @name = options[:name]
    @purchase_price = 150

    @purchased = false
    @owner = nil
  end

  def process(game, rolled = [])
    if @purchased == true && game.current_player != @owner
      puts "#{game.current_player.name} paid #{@owner.name} $#{rent(sum(rolled))}"
      game.current_player.cash -= rent(sum(rolled))
      @owner.cash += rent(sum(rolled))
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

  def rent(roll_summed)
    if owns_both?
      roll_summed * 10
    else
      roll_summed * 4
    end
  end

  private

  def sum(rolled)
    rolled.inject(0, :+)
  end

  def owns_both?
    @owner.owned_properties.select{|property| property.class == Utility }.count == 2
  end
end
