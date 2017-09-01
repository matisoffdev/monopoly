class Property
  attr_accessor :purchased, :owner

  def initialize(options)
    @purchased = false
    @owner = nil

    options.each do |key, value|
      self.class.class_eval { attr_reader key }

      instance_variable_set("@#{key}", value)
    end
  end
end
