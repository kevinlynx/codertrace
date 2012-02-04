class MicroPost < ActiveRecord::Base
  belongs_to :user
  validates :url, :title, :description, :tag, :presence => true
  default_scope :order => 'pub_date DESC'
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  def self.create_all_posts
    users = User.all
    users.each do |user|
      user.create_post_from_entries
    end
  end

  private
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", { :user_id => user })
    end
end
