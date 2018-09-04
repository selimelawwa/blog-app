class WelcomeController < ApplicationController
  def index
  	@article = current_user.articles.build if logged_in?
  	@feed_items = current_user.feed.paginate(page: params[:page], per_page: 10) if logged_in?
  end
end
