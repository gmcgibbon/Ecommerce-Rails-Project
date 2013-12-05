class ShopController < ApplicationController
	
	def index
		@games = Game.order("created_at DESC").limit(5)
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
		@platform = Platform.find params[:platform][:id] unless params[:platform].nil?
		@platform ||= Platform.find(1)
		@games = @platform.games
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(10)
	end

	def shop_rating
		@ratings = Game.uniq.pluck(:rating)
		@rating = params[:rating_filter][:rating] unless params[:rating_filter].nil?
		@rating ||= @ratings.first
		@games = Game.where(:rating => @rating)
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(10)
	end

	def shop_price
		@price_h_to_l = params[:price_filter][:price] == "high" unless params[:price_filter].nil?
		@price_h_to_l ||= false
		@price_h_to_l ? @games = Game.order("price DESC") : @games = Game.order("price ASC")
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(10)
	end

	def shop_date
		@newest = params[:date_filter][:date] == "newest" unless params[:date_filter].nil?
		@newest ||= false
		@newest ? @games = Game.order("created_at DESC") : @games = Game.order("created_at ASC")
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(10)
	end

	def checkout
		if @cart.empty?
			redirect_to root_url
		else
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
	end

	def place_order
		if @cart.empty?
			redirect_to root_url
		else
			@order = Order.new params[:order]
			@payment_method = PaymentMethod.find(@order.payment_method_id)
			@customer = Customer.where("first_name LIKE '"+params[:customer][:first_name]+"'")
													.where("last_name LIKE '"+params[:customer][:last_name]+"'")
													.where("address LIKE '"+params[:customer][:address]+"'")
													.where("city LIKE '"+params[:customer][:city]+"'")
													.where("postal_code LIKE '"+params[:customer][:postal_code]+"'")
													.where("email LIKE '"+params[:customer][:email]+"'")
													.where("province_id LIKE '"+params[:customer][:province_id]+"'").uniq
			@customer.empty? ? @customer = Customer.new(params[:customer]) : @customer = @customer.first
			
			begin 
				@total = 0.0

				if @customer.save!

					@order.customer_id = @customer.id
					@order.status = "New"
					@order.pst = @customer.province.pst
					@order.gst = @customer.province.gst
					@order.hst = @customer.province.hst
					
					if @order.save!
						@cart.each do |item|
							game = Game.find(item[:id])


							cart_item = @order.cart_items.build
							cart_item.game_id = game.id
							cart_item.quantity = item[:quantity]
							cart_item.price = game.price
							@total += game.price * item[:quantity]
							@total += (@total * @customer.province.pst)
							@total += (@total * @customer.province.gst)
							@total += (@total * @customer.province.hst)

							cart_item.save!
						end

						session[:errors] = nil
						session[:cart] = nil

						if @order.payment_method_id == 2
							session[:checkout_details] = {}
							session[:checkout_details][:order] = @order.id
							session[:checkout_details][:cust] = @customer.id
							session[:checkout_details][:toal] = @total
							redirect_to process_paypal_path
						else
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

	def process_paypal
		total = session[:checkout_details][:toal]
		session[:req] = request = Paypal::Express::Request.new(
		  :username   => "",
		  :password   => "",
		  :signature  => ""
		  )
		session[:pay_req] = payment_request = Paypal::Payment::Request.new(
		  :currency_code => :CAD,
		  :description   => "Video Game Order - Brick With Buttons",
		  :quantity      => 1,
		  :amount        => total
		  )
		response = request.setup(
		  payment_request,
		  paypal_order_placed_url,
		  root_url
		  )
		redirect_to response.redirect_uri
	end

	def order_processed
		@order = Order.find(session[:checkout_details][:order])
		@customer = Customer.find(session[:checkout_details][:cust])
		@total = session[:checkout_details][:toal]

		request = session[:req]
		payment_request = session[:pay_req]
		flash.now[:msg] = "Your order has been processed!"

		response = request.checkout!(
  		params[:token],
  		params[:PayerID],
  		payment_request
		)

		session[:req] = nil
		session[:pay_req] = nil
		session[:checkout_details] = nil
	end

	def redirect_root
		redirect_to root_url
	end
end
