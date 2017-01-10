module CartHelper
  def current_cart
    if !session[:cart_id].nil?
      cart = Cart.find(session[:cart_id])
      if cart == nil
        cart = Cart.create
        session[:cart_id] = cart.id
        cart
      end
      cart
    else
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end

  # TODO: destroy the cart in backend?
  def destroy_cart
      session[:cart_id] = nil
  end
end
