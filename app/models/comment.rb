class Comment < ActiveRecord::Base
  attr_accessible :body, :user, :post, :topic
  belongs_to :post
  belongs_to :user

  after_create :send_favorite_emails

  default_scope order('created_at DESC')
  default_scope order('updated_at DESC')
  
  validates :body, length: { minimum: 5 }, presence: true
  validates_presence_of :user, :post

private

  def send_favorite_emails
    self.post.favorites.each do |favorite|
      FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      if favorite.user_id != self.user_id && favorite.user.email_favorites?
        FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      end
    end
  end
end 