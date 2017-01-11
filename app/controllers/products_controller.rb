class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    @variant_id = params[:variant] ? @product.find_variant_id(params[:variant]).first.id : 1
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
  end

  private

  def search_params
    params.fetch(:search, {}).permit(:search_text, :category)
  end
end
