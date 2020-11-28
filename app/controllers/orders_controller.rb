class OrdersController < ApplicationController

  before_action :set_product, except: [:artist_sales, :fan_purchase, :register_order_state]
  before_action :order_params, only: [:create]
  before_action :set_buyer, only: [:create]
  before_action :set_address, only: [:create]
  before_action :authenticate_user!
  before_action :mercadopago_authentication
  before_action :authenticate_fan!, only: [:fan_purchases]
  before_action :authenticate_artist!, only: [:artist_sales]
  before_action :set_artist, only: [:artist_sales]
  before_action :set_fan, only: [:fan_purchases]

  # GET /artists/:artist_name/products/:id/buy

  # POST /artists/:artist_name/products/:id/buy
  def create
    delivery = self.order_params[:delivery] == "true" ? true : false
    units = self.order_params[:units].to_i
    @order = Order.new(units: units, product: @product, fan: current_user.profile, delivery: delivery, buyer: @buyer, address: @actual_address)

    respond_to do |format|
      if @order.valid? && @buyer.save
        stock_validation_and_response_with(format)
      else
        flash[:error] = 'La operación no se pudo realizar, por favor revise los datos ingresados e intente nuevamente!'
        format.html { redirect_back fallback_location: artist_product_url(@product.artist, @product) }
      end
      end
  end

  #GET /artists/:name/my_sales
  def artist_sales
    @orders = (@artist.products.collect {|product| product.orders}).flatten.collect {|order| $mp.get_preference(order.preference_id.to_s)}
    @products = product_for_each_order
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:product, :units, :delivery, buyer: [:name, :surname, :dni, :phone, address: [:state, :city, :street_name, :street_number, :apartament, :zip]])
  end  

  def set_address
    if order_params[:delivery] == "true"
      address_params = order_params.delete(:buyer).delete(:address)
      address_params = address_params.keep_if {|k,v| !v.nil? }
      if address_params.keys.include?("state") && address_params.keys.include?("city") &&  address_params.keys.include?("street_name") &&
          address_params.keys.include?("street_number") && address_params.keys.include?("zip")
        address_params[:state] = CS.states(:AR)[address_params[:state]]
        @actual_address = Address.find_or_create_by(address_params)
      end
    end
  end

  def set_buyer
    buyer_params = order_params.delete(:buyer).except(:address)
    buyer_params["email"] = current_user.email
    @buyer = Buyer.find_or_create_by(dni: buyer_params["dni"]) do |buyer|
      buyer.name = buyer_params["name"]
      buyer.surname = buyer_params["surname"]
      buyer.phone = buyer_params["phone"]
      buyer.email = current_user.email
    end
  end


  def product_for_each_order
    byebug
    @orders.collect do |order|
      @orders.delete(order) if order["response"]["items"].nil?
    end
    return ((@orders.collect {|order| order["response"]["items"][0]}).collect {|item| Product.find(item["id"])}).to_enum
  end

  def stock_validation_and_response_with(http_response)
    if @product.stock_greater_or_equals_than? @order.units
      @product.update_stock_after_new_order(@order.units)
      @preference = @order.create_checkout_with()
      http_response.html { redirect_to @preference["response"]["sandbox_init_point"] }
    else
      flash[:error] = 'No hay stock suficiente para satisfacer su demanda. Por favor, intente más tarde.'
      http_response.html { redirect_back fallback_location: artist_product_url(@product.artist, @product) }
    end
  end

  def mercadopago_authentication
    require 'mercadopago.rb'
    $mp = MercadoPago.new(Figaro.env.mercadopago_access_token)
  end

end
