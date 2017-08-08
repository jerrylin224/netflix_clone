class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(text)
    return [] if text.blank?
    where("title LIKE ?", "%#{text}%").order(:created_at)
  end
end
