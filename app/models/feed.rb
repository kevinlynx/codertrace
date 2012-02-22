require 'rss'

class Feed < ActiveRecord::Base

  def outdated? 
    Time.now.utc - download_at > 60 * 5
  end

  # get a RSS object if the rss content does not exist, download it by delayed_job first.
  def self.get_rss(rss_url, jobs_id)
    feed = Feed.find_by_url rss_url.downcase
    if feed.nil? or feed.outdated?
      FeedJob.schedule(rss_url, jobs_id)
      return nil
    end
    rss = nil
    begin
      rss = RSS::Parser.parse feed.content
    rescue
      logger.error "parse rss failed #{rss_url}"
      rss = nil
    end
    rss
  end

  def self.has_cache?(rss_url)
    feed = Feed.find_by_url rss_url.downcase
    not feed.nil? and not feed.outdated?
  end
end

