class PurchasableSquare
  attr_accessor :purchased, :owner

  def initialize
    @purchased = false
    @owner = nil
  end

  private

  def player_can_afford?(player)
    player.cash - @purchase_price > 0
  end
end
