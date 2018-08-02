class PhotosController < ApplicationController


  def destroy
    @photo = Photo.find(params[:id])
    @product = @photo.product
    @photo.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: edit_artist_product_url(@product.artist, @product), notice: 'Image has been deleted' }
    end
  end

end
