class InvitationsController < ApplicationController
  before_action :require_login

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))

    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      flash[:error] = "Something wrong with your input."
      render :new
    end
  end


  private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end