class WelcomeController < ApplicationController
  def index
  	@article = current_user.articles.build if logged_in?
  end
end
