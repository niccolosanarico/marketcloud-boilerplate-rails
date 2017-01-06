class CartController < ApplicationController
  include CartHelper

  def add
    # Record addition in Google analytics
    product = Product.find(add_cart_params[:product_id])

    tracker do |t|
      t.google_analytics :enhanced_ecommerce, {
        type: 'addProduct',
        id: product.id,
        name: product.name,
        sku: product.sku,
        category: product.category().name,
        price: product.price
      }
       t.google_analytics :send, {
         type: 'event',
         category: 'button',
         action: 'click',
         value: 'addToCart'
       }
    end
    # add item to the cart
    current_cart.add!([{ product_id: add_cart_params[:product_id], quantity: add_cart_params[:quantity] }])
    # and navigate to the cart
    redirect_to cart_path
  end

  def update
    # update an item quantity to the cart
    current_cart.update!([{ product_id: add_cart_params[:product_id], quantity: add_cart_params[:quantity] }])
    # and navigate to the cart
    redirect_to cart_path
  end

  def remove
    # Record addition in Google analytics
    product = Product.find(remove_cart_params[:product_id])

    tracker do |t|
      t.google_analytics :enhanced_ecommerce, {
        type: 'addProduct',
        id: product.id,
        name: product.name,
        sku: product.sku,
        category: product.category().name,
        price: product.price
      }
      t.google_analytics :send, {
        type: 'event',
        category: 'button',
        action: 'click',
        value: 'removeFromCart'
      }
    end
    # add item to the cart
    current_cart.remove!([{ product_id: remove_cart_params[:product_id] }])
    # and navigate to the cart
    redirect_to cart_path
  end

  def show
    @cart = Cart.find(current_cart.id)
  end

  private
    def add_cart_params
      params.require(:cart).permit(:product_id, :quantity)
    end

    def remove_cart_params
      params.require(:cart).permit(:product_id)
    end
end
