class Cart < Marketcloud::Cart

  def total
    items.reduce(0) { |total, i| (i['has_variants'] ? i["variant"]["price"]*i["quantity"] : i["price"]*i["quantity"]) + total }
  end

  def vat
    total * Marketcloud.configuration.application.tax_rate / 100
  end

  def items_count
    items.reduce(0) { |total, i| i["quantity"] + total }
  end

  def weight
    items.reduce(0) { |total, i| (i["weight"]*i["quantity"]) + total }
  end

  def volume
    items.reduce(0) do
      |total, i| (i["width"]*i["height"]*i["depth"]*i["quantity"])/(100*100*100) + total
    end
  end
end
