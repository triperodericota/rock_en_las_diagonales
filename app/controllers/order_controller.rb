class OrderController < ApplicationController

  before_action :set_product
  before_action :order_params
  before_action :buyer_params, only:[:create]
  before_action :set_buyer, only: [:create]
  before_action :mercadopago_authentication, only: [:create]

  # POST /artists/:artist_name/products/:id/buy
  def create
    @order = Order.new(order_params)
    @order.product = @product
    @order.fan = @buyer
    main_photo = @product.photos.first.image.url || nil

    # mercadopago preference checkout
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
            { 	 "name": params[:name],
                 "surname": params[:surname],
                 "email": @buyer.user.email,
                 "date_created": DateTime.current,
                 "phone": {
                     "area_code": params[:phone],
                     "number": params[:phone]
                 },
                 "identification":
                     {  "type": "DNI",
                        "number": params[:dni]
                     },
                "address":
                    {   "street_name": params[:street_name],
                        "street_number": params[:street_number],
                        "zip_code": params[:zip]
                    }

            }
    }
    @preference = $mp.create_preference(@preferenceData)
    #respond_to do |format|
    #  if @order.save
    #    format.html { redirect_to root_path }
    #  else
    #    format.html { redirect_back fallback_location: artist_product_url(@product.artist, @product) }
    #  end
    #end
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

  def buyer_params
    p params
    params.permit(:name, :surname, :dni, :phone, :state, :street_name, :street_number, :zip)
  end

  def set_buyer
    @buyer = current_user.profile if current_user.fan?
  end

end
