class Railroad
  attr_accessor :name, :purchased, :owner
  attr_reader :purchase_price

  def initialize(options)
    @name = options[:name]
    @purchased = false
    @owner = nil
    @purchase_price = 200
  end

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
