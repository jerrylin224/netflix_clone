class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, { only_integer: true }

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_columns(rating: new_rating)
    else
      review = Review.new(user_id: user.id, video_id: video.id, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  private

  def review
    @review ||= Review.find_by(user_id: user.id, video_id: video.id)
  end
end