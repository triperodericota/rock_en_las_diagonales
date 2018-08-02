class ProductsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_artist!, except: [:show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_artist
  before_action :photos_enumerator, only: [:show]


  # GET /artists/:artist_name/products
  def index
    @products = @artist.products
  end

  # GET /artists/:artist_name/products/1
  def show
  end

  # GET /artists/:artist_name/products/new
  def new
    @product = Product.new
    @product.photos.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /artists/:artist_name/products
  def create
    @product = Product.new(product_params)
    @product.artist = @artist

    respond_to do |format|
      if @product.save
        create_photos
        format.html { redirect_to artist_products_path(@artist.name), notice: 'Product was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /artists/:artist_name/products/1
  def update
    respond_to do |format|
      if @product.update(product_params)
        update_photos
        format.html { redirect_to artist_products_path(@artist.name), notice: 'Product was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /artists/:artist_name/products/1
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to artist_products_path(@artist.name), notice: 'Product was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :stock, photos_attributes: [ ])
    end

    def create_photos
      photos = params[:product][:photos_attributes]
      if !photos.nil?
        photos.each_pair do |number_photo, photo|
           if !photo.nil?
             Photo.create(product: @product, image: photo["image"])
           end
        end
      end
    end

    def update_photos
      photos = params[:product][:photos_attributes]
      if !photos.nil?
        photos.each_pair do |number_photo, photo|
          # add new photo
          if !photo.nil? && !photo.has_key?("id")
            Photo.create(product: @product, image: photo["image"])
          end
          # update saved photo (change older by a new photo)
          if !photo.nil? && photo.has_key?("id") && photo.has_key?("image")
            Photo.destroy(photo["id"])
            Photo.create(product: @product, image: photo["image"])
          end
        end
      end
    end

    def photos_enumerator
      @photos = @product.photos.to_enum
    end
end
