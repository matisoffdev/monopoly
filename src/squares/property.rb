require_relative "purchasable_square"

class Property < PurchasableSquare
  attr_accessor :purchased, :owner, :houses

  def initialize(options)
    @purchased = false
    @owner = nil
    @houses = 0

    options.each do |key, value|
      self.class.class_eval { attr_reader key }

      instance_variable_set("@#{key}", value)
    end
  end

  def process(game, rolled = [])
    if @purchased == true && game.current_player != @owner
      puts "#{game.current_player.name} paid #{@owner.name} $#{calculated_rent}"
      game.current_player.cash -= calculated_rent
      @owner.cash += calculated_rent
    elsif @purchased == false
      puts "Would you like to purchase this property? (y/n)"
      wants_to_purchase = gets.chomp

      return process(game) if !["y", "n"].include?(wants_to_purchase)

      if wants_to_purchase == "y" && player_can_afford?(game.current_player)
        @purchased = true
        @owner = game.current_player
        game.current_player.owned_properties.push(self)
        game.current_player.cash -= @purchase_price
        puts "#{game.current_player.name} purchased #{@name}, and has $#{game.current_player.cash} left."

        if has_monopoly?
          puts "#{game.current_player.name} has a monopoly on the color of #{@color}"
        end
      end
    end
  end

  private

  # TODO: take into consideration monopolies and houses/hotels
  def calculated_rent
    if houses == 0
      if has_monopoly?
        @monopoly_rent
      else
        @rent
      end
    else
      case houses
      when 1
        @rent_with_one_house
      when 2
        @rent_with_two_houses
      when 3
        @rent_with_three_houses
      when 4
        @rent_with_four_houses
      when 5
        @rent_with_hotel
      end
    end
  end

  def has_monopoly?
    count_color = @owner.owned_properties.select do |property|
      property.is_a?(Property) && property.color == @color
    end.count

    if ["Brown", "Dark Blue"].include?(@color)
      count_color == 2
    else
      count_color == 3
    end
  end
end
