class PaymentsController < ApplicationController

  before_action :payment_params

  def create
    # parameters example
    #   Parameters: {"collection_id"=>"1231121088", "collection_status"=>"approved",
    # "payment_id"=>"1231121088", "status"=>"approved", "external_reference"=>"null",
    # "payment_type"=>"credit_card", "merchant_order_id"=>"1982124792", "prefe rence_id"=>"239666363-fdfcb09c-1549-4a5b-bbf1-7479b90c3a88",
    # "site_id"=>"MLA", "processing_mode"=>"aggregator", "merchant_account_id"=>"null"}

    @order = Order.where(["preference_id = ?", payment_params["preference_id"]]).first
    external_reference_value = payment_params["external_reference"] == "null" ? nil : payment_params["external_reference"]
    @payment = Payment.new(status: payment_params["status"], payment_type: payment_params["payment_type"],
                            merchant_order_id: payment_params["merchant_order_id"], order: @order,
                            mercadopago_payment_id: payment_params["payment_id"], external_reference: external_reference_value)

    respond_to do |format|
      if @payment.save
        @order.payment = @payment
        @order.save
        flash[:notice] = "Su compra se realizó correctamente.\n Su pago se encuentra #{@payment.status}"
        format.html { redirect_to my_purchases_fan_path(current_user)}
      else
        flash[:error] = "No pudo realizar su comprar, los datos de su tarjeta no pudieron ser validados"
        format.html { redirect_to buy_artist_product_path(@order.product.artist, @order.product) }
      end
    end
  end
  
  private
  
  def payment_params
    params.permit(:payment_id, :status, :external_reference, :payment_type, :merchant_order_id, :preference_id)
  end

end
