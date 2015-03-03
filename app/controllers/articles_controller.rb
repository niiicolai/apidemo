class ArticlesController < ApplicationController
	before_action :authenticate_user!

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
