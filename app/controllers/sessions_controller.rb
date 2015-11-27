class SessionsController < ApplicationController
  layout false

  def new
    redirect_to '/auth/google_oauth2/'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth["provider"],  :uid => auth["uid"]).first_or_initialize(
      :refresh_token => auth["credentials"]["refresh_token"],
      :access_token => auth["credentials"]["token"],
      :expires => auth["credentials"]["expires_at"],
      :name => auth["info"]["name"],
      :email => auth["info"]["email"],
    )

    if user.save
      session[:user_id] = user.uid
      session[:provider] = user.provider
      @current_user = user
      @login_res = user.to_json(:only => [:name, :email]).html_safe
    else
      @login_res = { :errors => user.errors.full_messages }.to_json.html_safe
    end
  end

  def fail
    @login_res = { :errors => params[:message] }.to_json.html_safe
    render :create
  end

  def destroy
    reset_session
    respond_to { |format|
      format.html {
        redirect_to root_url,  :notice => "Signed out!"
      }
      format.json {
        render :json => { :success => true }
      }
    }
    reset_session
    @current_user = nil
  end

end
