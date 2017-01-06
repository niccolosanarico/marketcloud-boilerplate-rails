class CheckoutController < ApplicationController

  before_action :signin, only: [:address, :shipment, :payment]

  def address
    # Record the checkout process
    tracker do |t|
      t.google_analytics :enhanced_ecommerce, {
        type: 'checkout',
        step: 1
      }
      t.google_analytics :send, {
        type: 'pageview'
      }
    end

    @cart = Cart.find(current_cart.id)
    @addresses = Address.find_by_user(current_user.id)

    render :address
  end

  def shipment
    # Record the checkout process
    tracker do |t|
      t.google_analytics :enhanced_ecommerce, {
        type: 'checkout',
        step: 2
      }
      t.google_analytics :send, {
        type: 'pageview'
      }
    end

    # Check for correct data
    if shipment_params[:shipping_address].nil?
      flash[:error] = I18n.t("select_address_error")
      redirect_back(fallback_location: root_path) and return
    end

    @cart = Cart.find(current_cart.id)
    @shipping_address = Address.find(shipment_params[:shipping_address])

    # Check whether the shipping and the billing are the same
    if shipment_params[:billing_address]
      @billing_address = Address.find(shipment_params[:billing_address])
    else
      @billing_address = @shipping_address
    end

    #TODO: Compute the correct shipping options and costs
    @shippings = Shipping.all()

    render :shipment
  end

  # To complete this action you need to be logged in
  def payment

    # Record the checkout process
    tracker do |t|
      t.google_analytics :enhanced_ecommerce, {
        type: 'checkout',
        step: 3
      }
      t.google_analytics :send, {
        type: 'pageview'
      }
    end

    # Check for correct data
    if payment_params[:shipping_id].nil?
      flash[:error] = I18n.t("select_shipping_error")
      redirect_back(fallback_location: root_path) and return
    end


    @payment = BraintreePayment.get_token(current_user.id)

    # Now I can build the order, but first check that there is not an existing one
    # TODO

    @order = Order.create(current_user.id,
                          current_cart.id.to_i,
                          payment_params[:shipping_address_id].to_i,
                          payment_params[:billing_address_id].to_i,
                          payment_params[:shipping_id].to_i)

    render :payment
  end

  # Payment completed!
  def review

    @order = Order.find(review_params[:order_id])
    @billing_address = Address.find(@order.billing_address['id'])
    @shipping_address = Address.find(@order.shipping_address['id'])
    @shipping = Shipping.find(@order.shipping_id)

    # Depending on environment!
    if Rails.env.development? || Rails.env.test?
      @payment = Payment.create(review_params[:order_id].to_i, "fake-valid-no-billing-address-nonce")
    else
      @payment = Payment.create(review_params[:order_id].to_i, params[:payment_method_nonce])
    end

    @products = @order.products.map { |p| Product.new(p) }

    # Destroy the cart
    destroy_cart

    flash.now[:success] = (I18n.t("order_success"))

    # Record the checkout process
    tracker do |t|
      t.google_analytics :enhanced_ecommerce, {
        type: 'purchase',
        id: @order.id,
        revenue: @order.total,
        tax: @order.taxes_total,
        shipping: @order.shipping_total

      }
      t.google_analytics :send, {
        type: 'pageview'
      }
    end

    render :review
  end



  private

    def address_params
      params.require(:checkout).permit(:cart_id)
    end

    def shipment_params
      params.require(:checkout).permit(
        :cart_id,
        :billing_address,
        :shipping_address
      )
    end

    def payment_params
      params.require(:checkout).permit(
        :cart_id,
        :billing_address_id,
        :shipping_address_id,
        :shipping_id
      )
    end

    def review_params
      params.require(:checkout).permit(
        :payment_method_nonce,
        :order_id
      )
    end

    def signin
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
end
