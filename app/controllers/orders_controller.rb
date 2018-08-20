class OrdersController < ApplicationController

  before_action :set_product, except: [:artist_sales, :fan_purchases]
  before_action :order_params, only: [:create]
  before_action :mercadopago_authentication
  before_action :authenticate_artist!, only: [:artist_sales]
  before_action :set_artist, only: [:artist_sales]
  before_action :authenticate_fan!, only: [:fan_purchases]
  before_action :set_fan, only: [:fan_purchases]

  # POST /artists/:artist_name/products/:id/buy
  def create
    @order = Order.new(units: params[:order][:units].to_i, product: @product)
    @order.fan = current_user.profile
    # take buyer and address params
    buyer_params = order_params.delete(:buyer).except(:address)
    address_params = order_params.delete(:buyer).delete(:address)

    set_buyer(buyer_params)
    @order.buyer = @buyer
    # check if user load fields for home delivery
    if @buyer.address.nil? && address_params.except(:apartament).values.all? {|v| !v.blank? }
      @address = Address.new(address_params)
      if @address.save
        @buyer.address = @address
        correct_address = true
      else
        correct_address = false
      end
    else
      # without address for home delivery
      correct_address = true
    end

    respond_to do |format|
      if @order.valid? && @buyer.save && correct_address
        if @product.stock_greater_or_equals_than? @order.units
          @product.update(stock: @product.stock - @order.units)
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
    main_photo = @product.main_photo
    street_name = @buyer.address.street_name unless @buyer.address.nil?
    street_number = @buyer.address.street_number unless @buyer.address.nil?
    zip = @buyer.address.zip unless @buyer.address.nil?
    @preferenceData = {
        "items": [
            { "id": @product.id,
              "title": @product.title,
              "quantity": @order.units,
              "unit_price": @product.price.to_f,
              "description": @product.description,
              "picture_url": main_photo,
              "currency_id":"ARS"
            }
        ],
        "payer":
            { 	 "name": @buyer.name,
                "surname": @buyer.surname,
                "email": @buyer.email,
                "date_created": DateTime.current,
                "phone": {
                    "area_code": @buyer.phone_cod_area,
                    "number": @buyer.phone_number
                },
                "identification":
                    {  "type": "DNI",
                       "number": @buyer.dni,
                    },
                "address":
                    {   "street_name": street_name,
                        "street_number": street_number,
                        "zip_code": zip
                    }

            },
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

  def set_buyer(buyer_params)
    @buyer = Buyer.find_by(dni: buyer_params[:dni]) || Buyer.new(buyer_params)
    @buyer.email = current_user.email if @buyer.email.nil?
  end

  def product_for_each_order(anOrdersCollection)
    ((anOrdersCollection.collect {|order| order["response"]["items"][0]}).collect {|item| Product.find(item["id"])}).to_enum
  end

end
