class RelationshipsController < ApplicationController
  before_action :require_login

  def index
    @relationships = current_user.following_relationships
  end
end