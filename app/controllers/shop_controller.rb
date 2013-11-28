class ShopController < ApplicationController
	def index
		@games = Game.order(:name)
		@platforms = Platform.order(:name)
	end
	def search
		@games = (Game.where("name LIKE ?", "%#{params[:keywords]}%") +
				 Game.where("genre LIKE ?", "%#{params[:keywords]}%") +
				 Game.where("developer LIKE ?", "%#{params[:keywords]}%")).uniq
	end
end
