class Category < Marketcloud::Category

  attr_accessor :all_products

  def get_first_children
    categories = ::Category.all
    categories.select { |c| c.parent_id == id }
  end

  def get_parent
    Category.find(parent_id)
  end

  # Ugly and inefficient way to build and paginate the set of products in a category tree
  def get_all_products(page: 1, per_page: 20)
    if !@all_products.nil?  && @all_products != []
      return @all_products.slice((page-1)*per_page, per_page)
    end

    @all_products = Product.find_by_category(id, per_page: 1000) #this is a potential HUGE bug TODO

    get_first_children.each do |cat|
      @all_products += cat.get_all_products(per_page: 1000) #this is a potential HUGE bug TODO
    end

    return @all_products.slice(0, per_page)
  end

  def pages(per_page: 20)
    return (@all_products.count.to_f / per_page).ceil unless @all_products.nil?
  end

  def count
    return @all_products.count
  end

  def build_taxon_tree
    taxon_root = ::Taxon.new(id)

    ::Category.all.each do |c|
      taxon_root.add_category_to_tree(c)
    end

    taxon_root
  end

  def self.get_roots
    categories = Category.all
    categories.select { |c| c.parent_id.nil? }
  end

  def self.belongs_to_category_tree?(category, product)
    belongs = false

    category.get_first_children.each do |cat|
      belongs ||= Category.belongs_to_category_tree?(cat, product)
    end

    return (product.category_id == category.id) || belongs
  end

end
