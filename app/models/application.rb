class Application < Marketcloud::Application

  def vat_for_products
    if ["products_only", "all"].include?(tax_type)
      return true
    end
    return false
  end

  def vat_for_shipping
    if ["shipping_only", "all"].include?(tax_type)
      return true
    end
    return false
  end

end
