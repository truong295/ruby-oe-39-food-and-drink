class ProductsController < ApplicationController
  autocomplete :product, :name
  before_action :load_product, only: :show
  before_action :recent_products, only: %i(show)



  def show
    @rating = Rating.new
    unless @recents.include? @product.id
      @recents.unshift(@product.id)
    end
    session[:recents] = @recents
  end

  def index
    respond_to do |format|
      format.html
      format.json {@products = Product.filter_product_by_name(params[:term]).page(params[:page])
                         .per(Settings.page.per_page) }
    end
  end


  private

  def load_product
    return if @product = Product.find_by(id: params[:id])

    flash[:danger] = t "product_detail.product_find_nil"
    redirect_to root_path
  end
end
