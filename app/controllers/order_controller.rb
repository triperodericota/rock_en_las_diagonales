class OrderController < ApplicationController

  before_action :set_product
  before_action :order_params
  before_action :set_buyer, only: [:create]


  # POST /artists/:artist_name/products/:id/buy
  def create
    @order = Order.new(order_params)
    @order.product = @product
    @order.fan = @buyer

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path }
      else
        format.html { redirect_back fallback_location: artist_product_url(@product.artist, @product) }
      end
    end
  end

  def cancel
    @order.cancel
  end

  def accept
    @order.accept
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:units)
  end

  def set_buyer
    @buyer = current_user.profile if current_user.fan?
  end

end
