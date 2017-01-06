class Product < Marketcloud::Product
  def category
    ::Category.find(category_id)
  end
end
