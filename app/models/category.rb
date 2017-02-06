class Category < Marketcloud::Category

  attr_accessor :all_products

  # Get the first level children categories  of the current category
  # @return an array of categories
  def get_first_children
    categories = ::Category.all
    categories.select { |c| c.parent_id == id }
  end

  def get_parent
    Category.find(parent_id)
  end

  # Ugly and inefficient way to build and paginate the set of products in a category tree
  # @param page the page you want to display
  # @param per_page how many products per page
  # @return an arary of products
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

  # Return how many pages there are given a certain number of products per page
  # @param per_page how many products per page
  # @return the number of pages
  def pages(per_page: 20)
    return (@all_products.count.to_f / per_page).ceil unless @all_products.nil?
  end

  # @return the total number of products
  def count
    return @all_products.count
  end

  # Build the tree of taxons (= categories)
  # @return the root of the tree of taxons
  def build_taxon_tree
    taxon_root = ::Taxon.new(id)

    ::Category.all.each do |c|
      taxon_root.add_category_to_tree(c)
    end

    taxon_root
  end

  # Find out the category roots
  # @return an array of categories that have no parent
  def self.get_roots
    categories = Category.all
    categories.select { |c| c.parent_id.nil? }
  end

  # Check whether a  product belongs to a branch of categories
  # @param category the category at the root of the branch
  # @param product the product to be found
  # @return true if the product belongs to the branch started by category
  def self.belongs_to_category_tree?(category, product)
    belongs = false

    category.get_first_children.each do |cat|
      belongs ||= Category.belongs_to_category_tree?(cat, product)
    end

    return (product.category_id == category.id) || belongs
  end

  # Override to_param for readable links
  # @return a string with id and name of the category
  def to_param
    "#{id}-#{name}"
  end
end
