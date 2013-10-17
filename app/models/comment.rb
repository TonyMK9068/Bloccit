class Comment < ActiveRecord::Base
  attr_accessible :body, :user, :post
  belongs_to :post
  belongs_to :user

  default_scope order('created_at DESC')


end
