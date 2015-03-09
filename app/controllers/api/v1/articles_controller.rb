class Api::V1::ArticlesController < ActionController::Base
	protect_from_forgery with: :null_session
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :authenticate

	def get_token
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
		render :json => { :info => "authenticated", :article => @user.articles.all }, :status => 200
	end

	def create
		@user.articles.create(:title => params[:article][:title], :content => params[:article][:content])
		render :json => { :info => "Article created" }, :status => 200
	end

	def destroy
		@article = @user.articles.find(params[:article][:id])
		@article.destroy
		render :json => { :info => "Article destroyed" }, :status => 200
	end

	def show
		@article = @user.articles.find(params[:article][:id])
		render :json => { :info => "Article showed", :article => @article }, :status => 200
	end

	def update
		@article = @user.articles.find(params[:article][:id])
		@article.update(:title => params[:article][:title], :content => params[:article][:content])
		render :json => { :info => "Article updated", :article => @article }, :status => 200
	end

	private
	def authenticate
		@user = User.find(params[:id])
		if @user.token == params[:token]

		else
			render :json => { :info => "unauthenticated" }, :status => 500
		end
	end

end