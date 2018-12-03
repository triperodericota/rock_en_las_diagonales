class OrdersController < ApplicationController

  before_action :set_product, except: [:artist_sales, :fan_purchases]
  before_action :order_params, only: [:create, :set_buyer]
  before_action :mercadopago_authentication
  before_action :authenticate_artist!, only: [:artist_sales]
  before_action :set_artist, only: [:artist_sales]
  before_action :authenticate_fan!, only: [:fan_purchases]
  before_action :set_fan, only: [:fan_purchases]

  # POST /artists/:artist_name/products/:id/buy
  def create
    @order = Order.new(units: params[:order][:units].to_i, product: @product, fan: current_user.profile, buyer: @buyer)
    # take and check address params
    address_params = order_params.delete(:buyer).delete(:address)
    correct_address = @buyer.check_address(address_params)

    respond_to do |format|
      if @order.valid? && @buyer.save && correct_address
        if @product.stock_greater_or_equals_than? @order.units
          @product.update_stock_after_new_order(@order.units)
          create_checkout
          @order.preference_id = @preference["response"]["id"]
          @order.save
          format.html { redirect_to @preference["response"]["sandbox_init_point"] }
        else
          flash[:error] = 'No hay stock suficiente para satisfacer su demanda. Por favor, intente más tarde.'
          format.html { redirect_back fallback_location: artist_product_url(@product.artist, @product) }
        end
      else
        flash[:error] = 'La operación no se pudo realizar, por favor revise los datos ingresados e intente nuevamente!'
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

  # mercadopago checkout
  def create_checkout
    @preferenceData = {
        "items": [ @product.hash_data_for_order(@order.units) ],
        "payer": @buyer.hash_data_for_order,
        "back_urls": {
            "success": "https://localhost:3000/fans/#{current_user.profile.id}/my_purchases",
            "pending": "https://localhost:3000/fans/#{current_user.profile.id}/my_purchases",
            "failure": "http://localhost:3000/artists/#{@product.artist.name}/products/#{@product.id}"
        },
        "auto_return": "approved"
    }
    @preference = $mp.create_preference(@preferenceData)
  end

  # /artists/:name/my_sales
  def artist_sales
    @orders = (@artist.products.collect {|product| product.orders}).flatten.collect {|order| $mp.get_preference(order.preference_id.to_s)}
    @products = product_for_each_order(@orders)
  end

  # /fans/:id/my_purchases
  def fan_purchases
    @orders = @fan.orders.collect {|order| $mp.get_preference(order.preference_id.to_s) }
    @products = product_for_each_order(@orders)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end


  def order_params
    params.require(:order).permit(:product, :units, buyer: [:name, :surname, :dni, :phone, address: [:state, :city, :street_name, :street_number, :apartament, :zip]])
  end

  def set_buyer
    buyer_params = order_params.delete(:buyer).except(:address)
    @buyer = Buyer.find_by(dni: buyer_params[:dni]) || Buyer.new(buyer_params)
    @buyer.email = current_user.email if @buyer.email.nil?
  end

  def product_for_each_order(anOrdersCollection)
    ((anOrdersCollection.collect {|order| order["response"]["items"][0]}).collect {|item| Product.find(item["id"])}).to_enum
  end

end
