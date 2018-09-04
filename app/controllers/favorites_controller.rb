class FavoritesController < ApplicationController
	def create
		@article = Article.find_by(id: params[:article_id])
		current_user.favorite(@article)
		redirect_to articles_path
		# respond_to do |f|
  #     		f.html { redirect_to @articles }
  #     		f.js
  #   	end

	end

	def destroy
		@article = Article.find_by(id: params[:article_id])
		current_user.unfavorite(@article)
		respond_to do |f|
	      f.html { redirect_to @articles }
	      f.js
	    end
	end
end
