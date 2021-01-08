class StaticPagesController < ApplicationController
  before_action :recent_products, only: :contact
  def home
    @products = Product.order_alphabet_name.page(params[:page])
                       .per(Settings.page.per_page)
  end

  def contact
    @recent_products = Array.new
    @recents.each do |id|
      product = Product.find_by id: id
      @recent_products<<product
    end
  end
end
