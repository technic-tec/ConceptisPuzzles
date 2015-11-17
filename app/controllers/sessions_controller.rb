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

    respond_to { |format|
      format.json {
        if user.save
          session[:user_id] = user.id
          render :json => user, :only => [:name, :email]
        else
          render :json => { :errors => user.errors.full_messages }, :status => 422
        end
      }
    }
  end

  def fail
    respond_to { |format|
      format.json {
        render :json => { :errors => params[:message] }, :status => 422
      }
    }
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
  end

end
