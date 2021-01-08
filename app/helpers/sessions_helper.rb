module SessionsHelper
  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def current_carts
    session[:carts] ||= Hash.new
    @carts = session[:carts]
  end

  def check_quantity
    return if params[:quantity].to_i <= @product.quantity &&
              params[:quantity].to_i >= Settings.product.min_quantity

    flash[:danger] = t "carts.invalid_quantity"
    redirect_to root_path
  end

  def subtotal price, quantity
    price * quantity
  end

  def count_items
    @count_item = session[:carts].size if session[:carts]
  end

  def check_admin
    redirect_to root_path unless check_user_admin?
  end

  def check_user_admin?
    current_user.admin?
  end

  def recent_products
    session[:recents] ||=Array.new
    @recents = session[:recents].take(4)
  end
end
