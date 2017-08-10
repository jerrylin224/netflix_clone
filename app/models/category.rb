class Category < ActiveRecord::Base
  default_scope { order(created_at: :desc) }
  has_many :videos

  validates_presence_of :name

  def recent_videos
    self.videos.first(6)
  end

  def self.recent_videos
      
  end
end