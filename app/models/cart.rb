class Cart < Marketcloud::Cart

  def total
    items.reduce(0) { |total, i| i["price"]*i["quantity"] + total }
  end

  def vat
    total * Marketcloud.configuration.application.tax_rate / 100
  end
end
