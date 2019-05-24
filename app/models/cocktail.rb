class Cocktail < ApplicationRecord
  has_many :doses, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, through: :doses
  validates :name, presence: true, uniqueness: true

  mount_uploader :photo, PhotoUploader

  def avg_rating
    total = self.reviews.count
    total_sum = 0.0
    if self.reviews.exists?
      self.reviews.each do |review|
        total_sum += review.rating
      end
      raw_rating = total_sum / total
      (raw_rating * 2).round.to_f / 2
    else
      0
    end
  end

  def avg_rating_dec
    total = self.reviews.count
    total_sum = 0.0
    if self.reviews.exists?
      self.reviews.each do |review|
        total_sum += review.rating
      end
      (total_sum.to_f / total).round(1)
    else
      return 0.0
    end
  end

  def reviews_count
    if self.reviews.count.nil?
      return 0
    else
      return self.reviews.count
    end
  end
end
