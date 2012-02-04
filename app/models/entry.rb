 
class Entry < ActiveRecord::Base
  belongs_to :user

  def self.create(hash, user)
    entry = Entry.new(hash)
    user.add_entry(entry)
    entry.user = user
    entry
  end

  def create_posts_from_rss(tag, jobs_id)
    ret = false
    rss = Feed.get_rss rss_url, jobs_id
    if rss.nil?
      return ret
    end
    if rss.class == RSS::Rss
      ret = true
      rss.items.each do |item|
        user.create_post_from_rss(item, tag) unless user.has_post?(item.link)
      end
    elsif rss.class == RSS::Atom::Feed
      ret = true
      rss.entries.each do |entry|
        user.create_post_from_atom(entry, tag) unless user.has_post?(entry.link.href)
      end
    else
      logger.warn "not support feed type #{rss.class}"
    end
    return ret
  end

  def wait_feed_cache(jobs_id)
    WaitFeedCache.add(rss_url, jobs_id)
  end

  def cached? 
    rss = Feed.has_cache? rss_url
    return true if rss
    false
  end

  def processing?
    ProcessJob.exist? rss_url
  end

  def complete(method)
    self.completed = 1
    if method == 'manual' 
    elsif method == 'blog'
      complete_blog
    elsif method == 'github'
      complete_github
    end
  end

  def completed?
    completed == 1
  end

  private
    def complete_blog
      self.completed = 0
      self.tag = "blog"
      EntryRssJob.schedule rss_url, id, user.id
    end

    def complete_github
      logger.info "!!!!!!!!!!complete_github #{url}"
      self.tag = "project"
      self.rss_url = url + '.atom'
      self.title = "Github page"
      self.description = "This is my Github page"
    end
end

