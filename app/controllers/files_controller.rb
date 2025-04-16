class FilesController < ApplicationController

  def get_image
    blob = ActiveStorage::Blob.find(params[:id])
    redirect_to url_for(blob)
  end
end
