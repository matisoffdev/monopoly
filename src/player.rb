class Player
  attr_accessor :name, :position, :cash,
    :owned_properties, :current_rolls, :jail

  def initialize(name)
    @name = name
    @position = 0
    @cash = 1500
    @owned_properties = []
    @current_rolls = 0
    @jail = {
      in_jail: false,
      rolls: 0
    }
  end

  def send_to_jail
    @position = 10
    @jail = {
      in_jail: true,
      rolls: 0
    }
  end

  def has_monopoly?(color)
    owned_of_color = @owned_properties.select do |property|
      property.is_a?(Property) && property.color == color
    end

    if ["Brown", "Dark Blue"].include?(color)
      owned_of_color.count == 2
    else
      owned_of_color.count == 3
    end
  end
end
