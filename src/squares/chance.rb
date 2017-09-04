class Chance
  attr_reader :position, :name, :purchased

  def initialize(options)
    @position = options[:position]
    @name = "Chance"
    @purchased = nil
  end

  def process(game, rolled = [])

  end
end
