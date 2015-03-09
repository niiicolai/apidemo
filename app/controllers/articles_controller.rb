class ArticlesController < ApplicationController
	before_action :authenticate_user!

	 def create_token
      user = User.find_by_email(params[:user][:email])
      if user.blank?
        render :json => { :info => "Couldn't find a user with that email"}, :status => 200
      else
        if user.valid_password?(params[:user][:password])
          access_token = SecureRandom.hex
          current_user.update(:token => access_token)
          render :json => { :info => "Logged in", :user => current_user }, :status => 200
        else
          render :json => { :info => "email or password is wrong"}, :status => 200
        end
      end
    end

	def index
		@article = current_user.articles.all
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		@article.update(art_params)
		redirect_to root_path
	end

	def create
		@article = current_user.articles.create(art_params)
		redirect_to root_path
	end

	def show
		@article = Article.find(params[:id])
	end

	def new
		@article = Article.new
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy
		redirect_to root_path
	end

	private
	def art_params
		params.require(:article).permit(:title, :content)
	end
end
