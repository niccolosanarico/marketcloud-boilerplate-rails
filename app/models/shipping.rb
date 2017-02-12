class Shipping < Marketcloud::Shipping

  #
  #
  # A bit of dirty approach to initialize values
  def initialize(attributes)
    super

    # The wrapper to the API does not judge original values, so I initialize them here
    @max_weight ||= 10000000000
    @min_weight ||= 0
    @max_depth  ||= 10000000000
    @min_depth 	||= 0
    @max_height ||= 10000000000
    @min_height ||= 0
    @max_width 	||= 10000000000
    @min_width 	||= 0
    @max_value 	||= 10000000000
    @min_value 	||= 0

  end

  # Compute the possible shipping methods
  # @param cart a cart, to compute shipping values
  # @param shipping_address to select the shipping method
  # @return an array of eligible shippings
  def self.find_shippings cart, shipping_address
    shippings = Shipping.all

    selectable_shippings = shippings.select do |s|
      max_volume = (s.max_width * s.max_height * s.max_depth).to_f / (100*100*100)

      if (cart.volume <= max_volume and cart.weight <= s.max_weight and cart.weight > s.min_weight and s.country_served?(shipping_address.country))
        true
      else
        false
      end
    end

    return selectable_shippings
  end

  # returns true if a given country is served
  # @param country a complete name of a country (e.g. Italy)
  # @return true if country is served by the curren shipping method
  def country_served? country
    self.zones.each do |zone|
      if zone["name"].downcase == country.downcase
        return true
      end
    end

    return false
  end

  # returns the cost of the shipment given a cart
  # @param cart a cart
  # @return the cost of shipping
  def cost_of_shipping cart
    self.base_cost + cart.items_count*self.per_item_cost
  end

end
