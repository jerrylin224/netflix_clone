class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  delegate :full_name, to: :user, prefix: :user
  delegate :title, to: :video, prefix: :video

  validates_presence_of :rating, :content
end