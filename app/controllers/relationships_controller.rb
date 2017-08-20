class RelationshipsController < ApplicationController
  before_action :require_login

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(leader_id: params[:leader_id], follower: current_user) unless current_user.follows?(leader) || current_user == leader
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.delete if relationship.follower == current_user 
    redirect_to people_path
  end
end