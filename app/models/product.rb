class Product < Marketcloud::Product

  # Return the product category
  # @return the category the product belongs to
  def category
    ::Category.find(category_id)
  end

  # Finds a variant given a set of variant definitions.
  # @param dimensions a hash with the variant dimensions
  # @return a variant or nil if none / more than one is found.
  def find_variant_id(dimensions) #a hash of dimensions
    variant = variants.select do |v|
      this = true
      dimensions.each do |dk, dv|
        this &&= (v.send(dk.downcase) == dv)
      end
      this
    end

    if variant.length == 1; return variant.first; end

    return nil
  end

  # Overrides to_param for readable links
  # @return a string with id and slug
  def to_param
    "#{id}-#{slug}"
  end
end
