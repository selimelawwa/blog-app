class FavoritesController < ApplicationController
	before_action :logged_in_user, only: [:create,:destroy,:index]
	def create
		@article = Article.find_by(id: params[:article_id])
		current_user.favorite(@article)
		redirect_back fallback_location: @articles
		# respond_to do |f|
  #     		f.html { redirect_to @articles }
  #     		f.js
  #   	end

	end

	def destroy
		@article = Article.find_by(id: params[:article_id])
		current_user.unfavorite(@article)
		redirect_back fallback_location: @articles
		# respond_to do |f|
	 #      f.html { redirect_to @articles }
	 #      f.js
	 #    end
	end

	def index
		@articles = current_user.favorite_articles.paginate(page: params[:page], per_page: 10) 
	end
end
