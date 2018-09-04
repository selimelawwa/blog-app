class ArticlesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy, :index]
	before_action :correct_user,   only: :destroy

    def index
    	#@articles = current_user.articles
    	@articles = Article.all
    	@favorite = Favorite.new
    end

	def create
	    @article = current_user.articles.build(article_params)
	    if @article.save
	      flash[:success] = "Article created!"
	      redirect_to root_url
	    else
	      #@feed_items = []
	      #render 'static_pages/home'
	      flash[:danger] = "Article NOT created!"
	    end
  	end

	def destroy
		@aritcle.destroy
    	flash[:success] = "Aritcle deleted"
   	 	redirect_to request.referrer || root_url
	end

	private

	    def article_params
	      params.require(:article).permit(:title,:content)
	    end
	    
	    def correct_user
	      @aritcle = current_user.articles.find_by(id: params[:id])
	      redirect_to root_url if @aritcle.nil?
    	end

end
