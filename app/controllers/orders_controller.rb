class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])

    if @order.nil? || current_user.nil? || @order.user_id != current_user.id
      flash[:error] = I18n.t('forbidden')
      redirect_to root_path and return
    end

    @billing_address = Address.find(@order.billing_address['id'])
    @shipping_address = Address.find(@order.shipping_address['id'])
    @shipping = Shipping.find(@order.shipping_id)
    @products = @order.products.map { |p| Product.new(p) }
    @items = @order.items.map { |i| { product_id: i["product_id"], quantity: i["quantity"], variant_id: i["variant_id"] } }

  end

end
