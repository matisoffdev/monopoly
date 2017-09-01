class Player
  attr_accessor :name, :position, :cash,
    :owned_properties, :current_turns, :jail

  def initialize(name)
    @name = name
    @position = 0
    @cash = 1500
    @owned_properties = []
    @current_turns = 0
    @jail = {
      in_jail: false,
      rolls: 0
    }
  end
end
