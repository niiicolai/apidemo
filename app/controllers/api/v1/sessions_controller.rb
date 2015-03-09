class Api::V1::SessionsController < Devise::SessionsController
    protect_from_forgery with: :null_session
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    before_filter :authenticate, :only => [:destroy]

    def create
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

    def destroy
      @user.update(:token => "")
      render :json => { :info => "Logged out" }, :status => 200
    end

    def failure
      render :json => { :error => "Login Credentials Failed" }, :status => 401
    end

    def authenticate
    @user = User.find(params[:id])
    if @user.token == params[:token]

    else
      render :json => { :info => "unauthenticated" }, :status => 500
    end
  end
  

  

end