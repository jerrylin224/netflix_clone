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
      handle_invitation
      # Stripe.api_key = Figaro.env.STRIPE_SECRET_KEY
      # begin
      #   StripeWrapper::Charge.create({
      #     :amount => 999,
      #     :card => params[:stripeToken], # obtained with Stripe.js
      #     :description => "Sign up charge for #{@user.email}"
      #   })
      # rescue Stripe::CardError => e
      #   flash[:danger] = e.message
      # end

      # AppMailer.send_welcome_email(@user).deliver
      flash[:notice] = "You have created your account!"
      session[:user_id] = @user.id
      redirect_to sign_in_path
      # 應該要register後直接sign_in才對啊＠＠，回去重寫一下
    else
      render 'new'
    end
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email, full_name: invitation.recipient_name)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end

    def handle_invitation
      if params[:invitation_token].present?
        invitation = Invitation.find_by(token: params[:invitation_token])
        @user.follow(invitation.inviter)
        invitation.inviter.follow(@user)
        invitation.update_columns(token: nil)
      end
    end
end