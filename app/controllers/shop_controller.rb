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
		@games = Kaminari.paginate_array(@games).page(params[:page]).per(10)
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
end
