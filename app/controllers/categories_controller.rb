class CategoriesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @page = params[:page] || 1
    @category = Category.find(params[:id].to_i)

    @products = @category.get_all_products(page: @page)
    @pages = @category.pages
    @category_roots = Category.get_roots

    build_breadcrumbs(@category)

    # Analytics SEGMENT
    # Record product list visit
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Product List Viewed',
      properties: {
        product: @products.map { |p| { product_id: p.id } },
        category: @category.name
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      }
    )

  end

  def index #unused
    # Category roots
    @category_roots = Category.get_roots

    add_breadcrumb "Tutte le categorie", categories_path
  end
end
