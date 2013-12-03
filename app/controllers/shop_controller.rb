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
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(5)
	end

	def shop_platform
		@platforms = Platform.all
		@platform = Platform.where("name LIKE ?", "%#{params[:platform]}%").first
	end

	def shop_rating
		@ratings = Game.uniq.pluck(:rating)
		@games = Game.where("rating LIKE ?", "%#{params[:game]}%")
	end

	def shop_price
		@games = Game.where("price LIKE ?", "%#{params[:game]}%")
	end

	def shop_date
		@games = Game.where("date LIKE ?", "%#{params[:game]}%")
	end

	def checkout
		redirect_to root_url if @cart.empty?

		@errors = flash.now[:errors] || []
		customer_attributes =  flash[:previous_customer] || {}
		order_attributes =  flash[:previous_order] || {}

		@customer = Customer.new customer_attributes
		@order = Order.new order_attributes

		

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
		@customer = Customer.where("first_name LIKE '"+params[:customer][:first_name]+"'")
												.where("last_name LIKE '"+params[:customer][:last_name]+"'")
												.where("address LIKE '"+params[:customer][:address]+"'")
												.where("city LIKE '"+params[:customer][:city]+"'")
												.where("postal_code LIKE '"+params[:customer][:postal_code]+"'")
												.where("email LIKE '"+params[:customer][:email]+"'")
												.where("province_id LIKE '"+params[:customer][:province_id]+"'").uniq
		@customer.empty? ? @customer = Customer.new(params[:customer]) : @customer = @customer.first
		
		begin 

			if @customer.save!

				@order.customer_id = @customer.id
				@order.status = "New"
				@order.pst = @customer.province.pst
				@order.gst = @customer.province.gst
				@order.hst = @customer.province.hst
				
				if @order.save
					@cart.each do |item|
						game = Game.find(item[:id])

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
					throw @order.errors
				end
			else
				throw @customer.errors
			end

		rescue => e
			errors = e.to_s.split(",")
			errors[0] = errors.first.sub "Validation failed: ", ""
			flash[:errors] = errors
			attributes = @customer.attributes.except("id","created_at","updated_at","id")
			flash[:previous_customer] = attributes
			flash[:previous_order] = @order.attributes.slice("payment_method_id")
			redirect_to checkout_path
		end

	end
end
