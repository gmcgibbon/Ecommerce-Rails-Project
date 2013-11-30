class CartController < ApplicationController

	def add_item
		session[:cart] << params[:id]
    redirect_to root_url
  end

  def remove_item
   	session[:cart] << params[:id]
    	redirect_to root_url
    end

    def clear_items
    	session[:cart] = nil
    	redirect_to root_url
    end
end
