class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path if !user
    end
  end

  def create
    if params[:password].length > 6
      user = User.find_by(token: params[:token])
      if user
        user.password = params[:password]
        user.generate_token
        user.save
        flash[:notice] = "You password has been changed. Please sign in."
        redirect_to sign_in_path
      else
        redirect_to expired_token_path
      end
    else 
      render :show
      flash[:error] = "Your new password should be more than 6 digits"
    end
  end
end