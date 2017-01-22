class CheckoutController < ApplicationController

  before_action :signin, only: [:address, :shipment, :payment]

  def address
    @cart = Cart.find(current_cart.id)
    @addresses = Address.find_by_user(current_user.id)

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Started',
      properties: {
        revenue: @cart.total,
        tax: @cart.vat,
        currency: Marketcloud.configuration.application.currency_code,
        products:
          @cart.items.map do |item|
            {
            id: item["id"],
            name: item["name"],
            price: item["price"],
            quantity: item["quantity"]
            }
          end
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Step Viewed',
      properties: {
        step: 1
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    render :address
  end

  def shipment

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Step Completed',
      properties: {
        step: 1
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    # Check for correct selection
    if shipment_params[:shipping_address].nil?
      flash[:error] = I18n.t("select_address_error")
      redirect_back(fallback_location: root_path) and return
    end

    @cart = Cart.find(current_cart.id)

    # Add relevant information to session to create the order later on
    begin
      @shipping_address = Address.find_and_check_user(shipment_params[:shipping_address], current_user.id)
      session[:shipping_address_id] = @shipping_address.id
    rescue Marketcloud::AddressNotFound
      flash[:error] = I18n.t("select_address_error")
      redirect_back(fallback_location: root_path) and return
    end

    # Check whether the shipping and the billing are the same
    begin
      if shipment_params[:billing_address]
        session[:billing_address_id] = Address.find_and_check_user(shipment_params[:billing_address], current_user.id).id
      else
        session[:billing_address_id] = session[:shipping_address_id]
      end
    rescue Marketcloud::AddressNotFound
      flash[:error] = I18n.t("select_address_error")
      redirect_back(fallback_location: root_path) and return
    end

    @shippings = Shipping.find_shippings(@cart, @shipping_address)

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Step Viewed',
      properties: {
        step: 2
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    render :shipment
  end

  def payment
    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Step Completed',
      properties: {
        step: 2,
        shippingMethod: payment_params[:shipping_id].to_i})

    # Check for correct data
    if payment_params[:shipping_id].nil?
      flash[:error] = I18n.t("select_shipping_error")
      redirect_back(fallback_location: root_path) and return
    end


    @payment = BraintreePayment.get_token(current_user.id)
    @cart = Cart.find(current_cart.id)
    shipping = Shipping.find(payment_params[:shipping_id])

    @shipping_cost = (shipping ? shipping.cost_of_shipping(@cart) : 0)
    @shipping_vat = (shipping ? shipping.cost_of_shipping(@cart) * Marketcloud.configuration.application.tax_rate/100 : 0)

    # Add relevant information to session to create the order later on
    session[:shipping_id] = shipping.id

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Step Viewed',
      properties: {
        step: 3
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    render :payment
  end

  # Payment completed!
  def review

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Payment Info Entered',
      properties: {
        shipping_method: session[:shipping_id],
        step: 3
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })


    if params[:payment_method_nonce].nil?
      flash[:error] = I18n.t("select_shipping_error")
      redirect_back(fallback_location: root_path) and return
    end

    session[:payment_method_nonce] = params[:payment_method_nonce]

    @billing_address = Address.find(session[:billing_address_id])
    @shipping_address = Address.find(session[:shipping_address_id])
    @shipping = Shipping.find(session[:shipping_id])
    @cart = Cart.find(current_cart.id)

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Checkout Step Viewed',
      properties: {
        step: 4
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    render :review

  end


  def confirm

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'checkout Step Completed',
      properties: {
        step: 4
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    # Now create the order

    if (session[:shipping_id] and session[:billing_address_id] and session[:shipping_address_id])
      @order = Order.create(current_user.id,
                            current_cart.id.to_i,
                            session[:shipping_address_id],
                            session[:billing_address_id],
                            session[:shipping_id])
    else
      flash[:error] = (I18n.t("generic_error"))
      redirect_back(fallback_location: root_path) and return
    end

    # Depending on environment!
    begin
      if Rails.env.development? || Rails.env.test?
        @payment = Payment.create(@order.id, "fake-valid-no-billing-address-nonce")
      else
        @payment = Payment.create(@order.id, session[:payment_method_nonce])
      end
    rescue Marketcloud::BraintreeProcessorDeclinedError
        flash[:error] = (I18n.t("payment_error"))
        redirect_back(fallback_location: root_path) and return
    end

    @billing_address = Address.find(session[:billing_address_id])
    @shipping_address = Address.find(session[:shipping_address_id])
    @shipping = Shipping.find(session[:shipping_id])
    @products = @order.products.map { |p| Product.new(p) }
    @items = @order.items.map { |i| { product_id: i["product_id"], quantity: i["quantity"], variant_id: i["variant_id"] } }

    # Destroy the cart
    destroy_cart

    # Analytics - SEGMENT
    Analytics.track(
      user_id: current_user ? current_user.id : -1,
      event: 'Order Completed',
      properties: {
        orderId: @order.id,
        revenue: @order.items_total,
        shipping: @order.shipping_total,
        tax: @order.taxes_total,
        currency: Marketcloud.configuration.application.currency_code,
        products: @products.map { |p|
          if ! p.variants
             { name: p.name, id: p.id, sku: p.sku, price: p.price, quantity: @order.items.select { |i| i["product_id"] == p.id }.first["quantity"] }
          else
             { name: p.name, id: p.id, sku: p.sku, price: p.price, quantity: @order.items.select { |i| i["product_id"] == p.id && i["variant_id"] == p.variants.first.variant_id }.first["quantity"] }
          end
        }
      },
      context: {
        'Google Analytics' => {
            clientId: ga_cookie
        }
      })

    flash.now[:success] = (I18n.t("order_success"))
    render 'orders/show'
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
        :shipping_id
      )
    end

    def review_params
      params.require(:checkout).permit(
        :payment_method_nonce
      )
    end

    def signin
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
end
