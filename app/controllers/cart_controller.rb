class CartController < ApplicationController

	def add_item
    item = @cart.find{ |cart_item| cart_item[:id]==params[:id] }
    if item.nil?
      item = {:id => params[:id], :name => params[:name], :quantity => 0}
      @cart << item
    end
    item[:quantity] +=1

    flash[:msg] = "#{params[:name]} has been added to your cart!"
    redirect_to(:back)
  end

  def remove_item
    @cart.delete(@cart.find{ |cart_item| cart_item[:id]==params[:id] })

    flash[:msg] = "#{params[:name]} has been removed to your cart!"
    redirect_to(:back)
  end

  def remove_all
   	session[:cart] = nil

    flash[:msg] = "Your cart is now empty!"
    redirect_to root_url
  end

end
