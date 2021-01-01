class Admin::BaseController < ApplicationController
  before_action :logged_in_admin, :check_admin

  layout "layouts/admin"

  private

  def logged_in_admin
    return if user_signed_in?

    store_location
    flash[:danger] = t "user.please_log_in"
    redirect_to new_user_session_path
  end
end
