class PhotosController < ApplicationController


  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Image has been deleted' }
    end
  end

end
