class ShopController < ApplicationController
	def index
		@games = Game.order(:name)
		@platforms = Platform.order(:name)
	end
end
