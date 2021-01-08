class Admin::ProductsController < ApplicationController
  def import
    Product.import_file params[:file]
    redirect_to root_path, notice: "Data imported"
  end
end
