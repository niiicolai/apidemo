class Api::V1::SessionsController < Devise::SessionsController
    protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.myapp.v1' }
    before_filter :authenticate, :only => [:destroy]
    skip_before_filter :verify_signed_out_user

    def create
      warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      begin
      access_token = SecureRandom.hex
      current_user.update(:token => access_token)
      render :json => { :info => "Logged in", :user => current_user }, :status => 200
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