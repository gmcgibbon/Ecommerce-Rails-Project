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

		@games = (name_results+genre_results+developer_results)
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
		@order = Order.new params[:order]
		@customer = Customer.new params[:customer]
		@success = false

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
						game.stock_quantity =- item[:quantity]

						cart_item = @order.cart_items.build
						cart_item.game_id = game.id
						cart_item.quantity = item[:quantity]
						cart_item.price = game.price

						cart_item.save
						game.save
					end
					session[:errors] = nil
					session[:cart] = nil
				else
					throw
				end
			else
				throw
			end

		rescue
			render checkout_path(@customer)
			#session[:errors] = [@customer.errors, @order.errors]
			#session[:error_attribs] = [@customer.attributes, @order.attributes]
			#redirect_to checkout_path
		end

	end
end
