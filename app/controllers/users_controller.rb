class UsersController < ApplicationController
  before_action :require_login, only: :show

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.create(user_params)

    if @user.valid?
      AppMailer.send_welcome_email(@user).deliver
      flash[:notice] = "You have created your account!"
      redirect_to sign_in_path
      # 應該要register後直接sign_in才對啊＠＠，回去重寫一下
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end