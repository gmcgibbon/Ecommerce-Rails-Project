class ShopController < ApplicationController
	def index
		@games = Game.order(:name)
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

		@games = Kaminari.paginate_array(@games).page(params[:page]).per(10)

		@count = @games.count
	end
	def paginate
	end
end
