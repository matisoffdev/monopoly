class CommunityChest
  attr_reader :position, :name, :purchased

  def initialize(options)
    @position = options[:position]
    @name = "Community Chest"
    @purchased = nil
  end
end
