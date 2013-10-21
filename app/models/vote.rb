class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  attr_accessible :value, :post

  after_save :update_post

  validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." } 

  def update_post
    self.post.update_rank
  end
end
