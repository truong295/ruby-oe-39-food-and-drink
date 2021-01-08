class ProductsController < ApplicationController
  before_action :load_product, only: :show
  before_action :recent_products, only: %i(show)

  def show
    @rating = Rating.new
    unless @recents.include? @product.id
      @recents.unshift(@product.id)
    end
    session[:recents] = @recents
  end

  private

  def load_product
    return if @product = Product.find_by(id: params[:id])

    flash[:danger] = t "product_detail.product_find_nil"
    redirect_to root_path
  end
end
