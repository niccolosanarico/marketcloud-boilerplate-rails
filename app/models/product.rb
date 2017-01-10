class Product < Marketcloud::Product
  def category
    ::Category.find(category_id)
  end

  def find_variant_id(dimensions) #a hash of dimensions
    variants.select do |v|
      this = true
      dimensions.each do |dk, dv|
        this &&= (v.send(dk.downcase) == dv)
      end
      this
    end
  end
end
