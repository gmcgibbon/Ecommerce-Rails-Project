class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :init_cart, :all_pages

  private

  def init_cart
  	@cart = session[:cart] ||= []
  end

  def all_pages
  	@all_pages ||= Page.order(:title)
  end

end
