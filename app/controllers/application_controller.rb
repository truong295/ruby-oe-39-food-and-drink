class ApplicationController < ActionController::Base
  before_action :set_locale, :load_category
  before_action :config_permitted_parameters, if: :devise_controller?

  include SessionsHelper

  protected

  def config_permitted_parameters
    added_attrs = [:name, :phone, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_category
    @categories = Category.orders_alphabet_category.select(:id, :name)
  end
end
