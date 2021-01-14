class SearchsController < ApplicationController
  before_action :check_key_search, only: %i(index)
  autocomplete :product, :name

  def index
    @products = Product.filter_product_by_name(@key).page(params[:page])
                       .per(Settings.page.per_page)
    return unless @products.empty?

    flash[:danger] = t "search.nil"
    redirect_to root_path
  end



  private

  def check_key_search
    @key = params[:name]
    return if @key.present?

    flash[:warning] = t "search.nil_key"
  end
end
