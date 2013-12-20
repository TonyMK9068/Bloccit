class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,
                  :avatar, :provider, :uid, :vote, :email_favorites

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates_length_of :name, in: 3..25, allow_blank: true
  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_create :set_member

  mount_uploader :avatar, AvatarUploader

  def has_avatar?
    self.avatar.present?
  end

  def name_or_email
    self.name.present?? self.name : self.email
  end

  def favorited?(post)
    self.favorites.where(post_id: post.id).first
  end

  def voted?(post)
    self.votes.where(post_id: post.id).first
  end
  
  def avatar_size(size)
    case size
    when "small" then self.avatar.small.url
    when "tiny" then self.avatar.tiny.url
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      pass = Devise.friendly_token[0,20]
      user = User.new(name:auth.extra.raw_info.name,
                      provider:auth.provider,
                      uid:auth.uid,
                      email:auth.info.email,
                      password: pass,
                      password_confirmation: pass
                      )
      user.skip_confirmation!
      user.save
    end
    user
  end

  def self.top_rated
    self.select('users.*'). # Select all attributes of the user
        select('COUNT(DISTINCT comments.id) AS comments_count'). # Count the comments made by the user
        select('COUNT(DISTINCT posts.id) AS posts_count'). # Count the posts made by the user
        select('COUNT(DISTINCT comments.id) + COUNT(DISTINCT posts.id) AS rank'). # Add the comment count to the post count and label the sum as "rank"
        joins(:posts). # Ties the posts table to the users table, via the user_id
        joins(:comments). # Ties the comments table to the users table, via the user_id
        group('users.id'). # Instructs the database to group the results so that each user will be returned in a distinct row
        order('rank DESC') # Instructs the database to order the results in descending order, by the rank that we created in this query. (rank = comment count + post count)
  end

  ROLES = %w[member moderator admin]
  def role?(base_role)
    role.nil? ? false : ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  private

  def set_member
    self.role = 'member'
  end
  
end