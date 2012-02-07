class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
    :description
  validates :name, :presence => true, :uniqueness => true
  has_many :entrys, :dependent => :destroy
  has_many :micro_posts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", 
      :class_name => 'Relationship', :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  def add_entry(entry)
    self.entrys << entry
    reset_posts_update_time
  end

  def all_entries
    entrys
  end

  def add_post(post)
    self.micro_posts << post
    logger.info "add post #{post.title} to #{name}"
  end

  def has_post?(url)
    micro_posts.each do |post|
      return true if url.downcase == post.url
    end
    return false
  end

  def refresh_self_and_following_posts(jobs_id)
    create_post_from_entries jobs_id
    following.each do |user|
      user.create_post_from_entries jobs_id
    end
  end

  def create_post_from_entries(jobs_id)
    return unless need_update_posts?
    ret = false
    entrys.each do |entry|
      if entry.completed?
        if entry.processing?
          entry.wait_feed_cache jobs_id
        else
          ret = entry.create_posts_from_rss entry.tag, jobs_id
        end
      end
    end
    set_posts_update_time if ret
  end

  def job_count_self
    return 0 unless need_update_posts?
    sum = 0
    entrys.each do |entry|
      if entry.completed?
        sum += 1 unless entry.cached?
      end
    end
    sum
  end

  def job_count_self_and_following
    sum = job_count_self
    following.each do |user|
      sum += user.job_count_self
    end
    sum
  end

  # return the job-list id
  def add_job_progress(sum)
    return JobProgress.add(sum) if sum > 0
    -1
  end

  def create_post_from_rss(item, tag)
    # item.pubDate.to_s fix an issue: http://stackoverflow.com/questions/9155190/insert-to-database-error-on-heroku-but-worked-locally-activerecordstatementin
    post = MicroPost.new(:description => item.description, :url => item.link, 
                         :title => item.title, :pub_date => item.pubDate.to_s,
                         :tag => tag)
    add_post(post)
    post.user = self
  end

  def create_post_from_atom(item, tag)
    post = MicroPost.new(:description => item.content.content || "No description",
                         :url => item.link.href || "No url", 
                         :title => item.title.content || "No title",
                         :pub_date => item.published.content.localtime.to_s,
                         :tag => tag)
    post.user = self
    add_post(post)
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id) unless following? followed
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy if following? followed
  end

  def feed
    MicroPost.from_users_followed_by(self)
  end

  def need_update_posts?
    return true if posts_update_at.nil?
    Time.now.utc - posts_update_at > 2 * 60
  end

  def set_posts_update_time
    self.posts_update_at = Time.now.utc
    save!
  end

  def reset_posts_update_time
    self.posts_update_at = Time.utc(1986)
    save!
  end
end
