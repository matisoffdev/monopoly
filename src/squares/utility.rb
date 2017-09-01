class Utility
  attr_accessor :purchased, :nil, :owner

  attr_reader :position, :name, :purchase_price

  def initialize(options)
    @position = options[:position]
    @name = options[:name]
    @purchase_price = 150

    @purchased = false
    @owner = nil
  end

  def rent(roll_summed)
    if owns_both?
      roll_summed * 10
    else
      roll_summed * 4
    end
  end

  private

  def owns_both?
    @owner.owned_properties.select{|property| property.class == Utility }.count
  end
end
