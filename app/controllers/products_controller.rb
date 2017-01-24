class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id].to_i)
    @variant_id = ( params[:variant] && @product.find_variant_id(params[:variant]) ) ? @product.find_variant_id(params[:variant]).id : @product.variants.first.id # default to the first variant possible
    add_breadcrumb "Home", :root_path
    build_breadcrumbs(Category.find(@product.category_id))

    # Analytics SEGMENT
    # Record product details visit
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Product Viewed',
      properties: {
        product_id: @product.id,
        sku: @product.sku,
        name: @product.name,
        price: @product.price,
        category: @product.category.name
    },
    context: {
      'Google Analytics' => {
          clientId: ga_cookie
      }
    })
  end

  def index
    @page = params[:page] || 1
    @q = search_params[:search_text] || nil
    @products = Product.all(page: @page, q: @q)

    if search_params[:category] && search_params[:category] != "all"
      category_filter = Category.get_roots().select {|c| c.name == search_params[:category]}.first
      @products.select! { |p| Category.belongs_to_category_tree?(category_filter, p) }
    end

    @count, @pages = Product.count_and_pages

    if @q
      # Analytics SEGMENT - if there was a query
      Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Products Searched',
      properties: {
        query: @q
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      });
    end

    # Analytics SEGMENT
    # Record product list visit
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Product List Viewed',
      properties: {
        products: @products.map { |p| { product_id: p.id } }
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      }
    )

  end

  private

  def search_params
    params.fetch(:search, {}).permit(:search_text, :category)
  end
end
