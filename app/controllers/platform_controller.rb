class PlatformController < ApplicationController
	def show
		@platform = Platform.find(params[:id])
	end
end
