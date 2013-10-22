class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  attr_accessible :post
end
