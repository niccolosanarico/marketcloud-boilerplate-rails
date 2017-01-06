class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    add_breadcrumb "Home", :root_path
    build_breadcrumbs(Category.find(@product.category_id))
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

    # Record product impressions in google analytics
    if @products
      tracker do |t|
        @products.each_with_index do |product, i|
          t.google_analytics :enhanced_ecommerce, {
            type: 'addImpression',
            id: product.id,
            name: product.name,
            sku: product.sku,
            category: product.category().name,
            price: product.price,
            position: i
          }
          t.google_analytics :send, {
            type: 'pageview'
          }
          end
      end
    end
  end

  private

  def search_params
    params.fetch(:search, {}).permit(:search_text, :category)
  end
end
