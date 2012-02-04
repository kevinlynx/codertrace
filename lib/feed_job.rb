class FeedJob < Struct.new(:url, :jobs_id)
  def perform
    require 'open-uri'
    content = ""
    begin
      open(url) do |s| content = s.read.force_encoding("UTF-8") end
    rescue OpenURI::HTTPError => the_error
      puts "Got a HTTP erro #{the_error.message} on #{url}"
      jobdone
    end
    begin
      feed = Feed.find_by_url(url)
      if feed
        feed.content = content
        feed.download_at = Time.now.utc
        feed.save
      else
        Feed.create(:url => url, :content => content, :download_at => Time.now.utc)
      end
    ensure
      jobdone
    end
    jobdone
  end

  def jobdone
    # job done
    ProcessJob.remove url
    if jobs_id > 0 # make sure increase finished only once.
      JobProgress.finished jobs_id 
      self.jobs_id = -1
      WaitFeedCache.got_cache url
    end
  end

  def self.schedule(url, jobs_id)
    url = url.downcase
    if ProcessJob.exist? url
      JobProgress.failed jobs_id
      return false
    end
    ProcessJob.add url
    Delayed::Job.enqueue FeedJob.new(url, jobs_id)
  end
end

