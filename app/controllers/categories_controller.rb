class CategoriesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def show
    @page = params[:page] || 1
    category = Category.find(params[:id])

    @products = category.get_all_products(page: @page)
    @pages = category.pages
    @category_roots = Category.get_roots

    build_breadcrumbs(category)
  end

  def index
    # Category roots
    @category_roots = Category.get_roots

    add_breadcrumb "Tutte le categorie", categories_path
  end
end
