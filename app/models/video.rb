class Video < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  belongs_to :category
  has_many :reviews,  -> { order(created_at: :desc) }
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(text)
    return [] if text.blank?
    where("title LIKE ?", "%#{text}%")
  end
end
