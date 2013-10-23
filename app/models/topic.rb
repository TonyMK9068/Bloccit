class Topic < ActiveRecord::Base
  attr_accessible :description, :name, :public, :post
  has_many :posts, dependent: :destroy

  scope :visible_to, lambda { |user| user ? scoped : where(public: true) }
end