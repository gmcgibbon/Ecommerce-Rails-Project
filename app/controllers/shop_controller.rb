class ShopController < ApplicationController
	
	def index
		@games = Game.order(:name).limit(5)
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(5)
		@platforms = Platform.order(:name)
	end

	def search
		name_results = Game.where("name LIKE ?", "%#{params[:keywords]}%").page(params[:page]).per(5)
		genre_results = Game.where("genre LIKE ?", "%#{params[:keywords]}%")
		developer_results = Game.where("developer LIKE ?", "%#{params[:keywords]}%")
		platform_results = Platform.where("name LIKE ?", "%#{params[:keywords]}%").first

		@games = (name_results + genre_results + developer_results)
		@games += platform_results.games unless platform_results.nil?
		@games = @games.uniq
		@count = @games.count
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(8)
	end

	def shop_platform
		@platforms = Platform.all
		@platform = Platform.where("name LIKE ?", "%#{params[:refined]}%").first
	end

	def shop_rating
		@ratings = Game.uniq.pluck(:rating)
		@games = Game.where("rating LIKE ?", "%#{params[:refined]}%")
	end

	def shop_price
		@games = Game.where("price LIKE ?", "%#{params[:refined]}%")
	end

	def shop_date
		@games = Game.where("date LIKE ?", "%#{params[:refined]}%")
	end

	def checkout
		redirect_to root_url if @cart.empty?
		#render :text => session[:errors].first 
		#render :text => session[:error_attribs].first
		#render :text => session[:error_attribs].last

		@customer = Customer.new(session[:error_attribs].first) unless flash[:error_attribs].nil?
		@customer ||= Customer.new
		@order = Order.new(session[:error_attribs].last) unless flash[:error_attribs].nil?
		@order ||= Order.new

		@customer_errors = session[:errors].first unless flash[:errors].nil?
		@customer_errors ||= []
		@order_errors = session[:errors].last unless flash[:errors].nil?
		@order_errors ||= []

		@payment_methods = PaymentMethod.order(:name)
		@provinces = Province.order(:name)
		@payment_methods = PaymentMethod.order(:name)
		cart_items = []
		@cart.each{|item| cart_items << Game.find(item[:id])}
		@cart_prices = []
		cart_items.each_index{|i| @cart_prices << cart_items[i].price * @cart[i][:quantity]}
	end

	def place_order
		redirect_to root_url if @cart.empty?
		@order = Order.new params[:order]
		@customer = Customer.where("first_name LIKE '"+params[:customer][:first_name]+"'")
												.where("last_name LIKE '"+params[:customer][:last_name]+"'")
												.where("address LIKE '"+params[:customer][:address]+"'")
												.where("city LIKE '"+params[:customer][:city]+"'")
												.where("postal_code LIKE '"+params[:customer][:postal_code]+"'")
												.where("email LIKE '"+params[:customer][:email]+"'")
												.where("province_id LIKE '"+params[:customer][:province_id]+"'").uniq
		@customer.empty? ? @customer = Customer.new(params[:customer]) : @customer = @customer.first
		
		begin 

			if @customer.save

				@order.customer_id = @customer.id
				@order.status = "New"
				@order.pst = @customer.province.pst
				@order.gst = @customer.province.gst
				@order.hst = @customer.province.hst
				
				if @order.save
					@cart.each do |item|
						game = Game.find(item[:id])
						game.stock_quantity -= item[:quantity]

						cart_item = @order.cart_item.build
						cart_item.game_id = game.id
						cart_item.quantity = item[:quantity]
						cart_item.price = game.price

						cart_item.save
						game.save

						session[:errors] = nil
						session[:cart] = nil
						
						flash.now[:msg] = "Your order has been processed!"
					end
				else
					throw
				end
			else
				throw
			end

		rescue => e
			render :text => e
		end

	end
end
