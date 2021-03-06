class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, success: "You are signed in, enjoy!"
    else
      flash[:error] = "There is something wrong with your email/password"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, success: "You are signed out."
  end
end