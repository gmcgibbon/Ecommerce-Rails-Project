class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_cart, :all_pages

  def all_pages
  	@pages = Page.order(:title)
  end

  private

  def init_cart
  	@cart = session[:cart] ||= []
  end
end
