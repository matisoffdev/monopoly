require "json"

# Corner squares
require_relative "squares/go"
require_relative "squares/jail"
require_relative "squares/free_parking"
require_relative "squares/go_to_jail"

# Properties
require_relative "squares/property"

# Income and Property taxes :(
require_relative "squares/income_tax"
require_relative "squares/luxury_tax"

# Railroads and utilities - variably priced rents
require_relative "squares/railroad"
require_relative "squares/utility"

# Community Chest and Chance cards
require_relative "squares/community_chest"
require_relative "squares/chance"

class Board
  attr_reader :squares

  def initialize
    @squares = {}

    @squares[0] = Go.new
    @squares[4] = IncomeTax.new
    @squares[10] = Jail.new
    @squares[20] = FreeParking.new
    @squares[30] = GoToJail.new
    @squares[38] = LuxuryTax.new

    community_chests.each do |community_chest_attributes|
      community_chest = CommunityChest.new(
        position: community_chest_attributes["position"]
      )

      @squares[community_chest_attributes["position"]] = community_chest
    end

    chances.each do |chance_attributes|
      chance = Chance.new(
        position: chance_attributes["position"]
      )

      @squares[chance_attributes["position"]] = chance
    end

    railroads.each do |railroad_attributes|
      railroad = Railroad.new(
        name: railroad_attributes["name"],
        purchase_price: 200
      )

      @squares[railroad_attributes["position"]] = railroad
    end

    utilities.each do |utility_attributes|
      utility = Utility.new(
        name: utility_attributes["name"],
        purchase_price: 200
      )

      @squares[utility_attributes["position"]] = utility
    end

    properties.each do |property_attributes|
      property = Property.new(
        name: property_attributes["name"],
        purchase_price: property_attributes["purchase_price"],
        color: property_attributes["color"],
        rent: property_attributes["rent"],
        monopoly_rent: property_attributes["monopoly_rent"],
        rent_with_one_house: property_attributes["rent_with_one_house"],
        rent_with_two_houses: property_attributes["rent_with_two_houses"],
        rent_with_three_houses: property_attributes["rent_with_three_houses"],
        rent_with_four_houses: property_attributes["rent_with_four_houses"],
        rent_with_hotel: property_attributes["rent_with_hotel"],
        house_cost: property_attributes["house_cost"],
        mortgage_cost: property_attributes["mortgage_cost"]
      )

      @squares[property_attributes["position"]] = property
    end
  end

  def position(index)
    @squares[index]
  end

  def properties
    JSON.parse(File.open(File.dirname(__FILE__) + "/../data/properties.json").read)
  end

  def railroads
    JSON.parse(File.open(File.dirname(__FILE__) + "/../data/railroads.json").read)
  end

  def utilities
    JSON.parse(File.open(File.dirname(__FILE__) + "/../data/utilities.json").read)
  end

  def community_chests
    JSON.parse(File.open(File.dirname(__FILE__) + "/../data/community_chests.json").read)
  end

  def chances
    JSON.parse(File.open(File.dirname(__FILE__) + "/../data/chances.json").read)
  end
end
