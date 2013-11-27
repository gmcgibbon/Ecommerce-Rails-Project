class GameController < ApplicationController
	def show
		@game = Game.find(params[:id])
	end
end
