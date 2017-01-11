class CartController < ApplicationController
  include CartHelper

  def add

    # add item to the cart
    current_cart.add!([{ product_id: add_cart_params[:product_id], quantity: add_cart_params[:quantity], variant_id: add_cart_params[:variant_id] }])
    # and navigate to the cart
    redirect_to cart_path
  end

  def update
    # update an item quantity to the cart
    current_cart.update!([{ product_id: add_cart_params[:product_id], quantity: add_cart_params[:quantity], variant_id: add_cart_params[:variant_id] }])
    # and navigate to the cart
    redirect_to cart_path
  end

  def remove
    # Record addition in Google analytics
    product = Product.find(remove_cart_params[:product_id])
    # add item to the cart
    current_cart.remove!([{ product_id: remove_cart_params[:product_id], variant_id: remove_cart_params[:variant_id] }])
    # and navigate to the cart
    redirect_to cart_path
  end

  def show
    @cart = Cart.find(current_cart.id)
  end

  private
    def add_cart_params
      params.require(:cart).permit(:product_id, :quantity, :variant_id)
    end

    def remove_cart_params
      params.require(:cart).permit(:product_id, :variant_id)
    end
end
