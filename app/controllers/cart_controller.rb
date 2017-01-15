class CartController < ApplicationController
  include CartHelper

  def add
    # add item to the cart
    current_cart.add!([{ product_id: add_cart_params[:product_id], quantity: add_cart_params[:quantity], variant_id: add_cart_params[:variant_id] }])

    # Analytics SEGMENT
    # Record addition in segment
    product = Product.find(add_cart_params[:product_id])
    if product.has_variants && add_cart_params[:variant_id]
      product = product.variants.select { |v| v.id == add_cart_params[:variant_id].to_i }.first
    end

    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Product Added',
      properties: {
        cart_id: current_cart.id,
        product_id: product.id,
        sku: product.sku,
        name: product.name,
        price: product.price
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    # and navigate to the cart
    redirect_to cart_path
  end

  def update
    # update an item quantity to the cart
    current_cart.update!([{ product_id: add_cart_params[:product_id], quantity: add_cart_params[:quantity], variant_id: add_cart_params[:variant_id] }])
    # and navigate to the cart

    #TODO -> not great from a speed point of view
    #TODO -> how to cause a cart update?
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js   {}
      format.json { head :no_content } #no need to return data here
    end
  end

  def remove
    # add item to the cart
    current_cart.remove!([{ product_id: remove_cart_params[:product_id], variant_id: remove_cart_params[:variant_id] }])

    # Analytics SEGMENT
    # Record removal in segment
    product = Product.find(remove_cart_params[:product_id])
    if remove_cart_params[:variant_id]
      product = product.variants.select { |v| v.id == remove_cart_params[:variant_id].to_i }.first
    end

    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Product Removed',
      properties: {
        cart_id: current_cart.id,
        product_id: product.id,
        sku: product.sku,
        name: product.name,
        price: product.price
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    # and navigate to the cart
    redirect_to cart_path
  end

  def show
    @cart = Cart.find(current_cart.id)

    respond_to do |format|
      format.html {
        # Analytics SEGMENT
        Analytics.track(
          user_id: current_user ? current_user.id : -1,
          event: 'Cart Viewed',
          properties: {
            cart_id: current_cart ? current_cart.id : -1,
            products:
              @cart.items.map do |item|
                {
                product_id: item["id"]
                }
              end
          },
          context: {
            'Google Analytics' => {
                clientId: ga_cookie
            }
          })

        render :show
      }
      
      format.js   {}
      format.json { render json: @cart }
    end
  end

  private
    def add_cart_params
      params.require(:cart).permit(:product_id, :quantity, :variant_id)
    end

    def remove_cart_params
      params.require(:cart).permit(:product_id, :variant_id)
    end
end
