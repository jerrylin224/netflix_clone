class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews,  -> { order(created_at: :desc) }
  has_many :queue_items

  validates_presence_of :title, :description

  def self.search_by_title(text)
    return [] if text.blank?
    where("title LIKE ?", "%#{text}%").order(:created_at)
  end
end
