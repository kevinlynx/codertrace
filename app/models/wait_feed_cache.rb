class WaitFeedCache < ActiveRecord::Base
  def self.got_cache(url)
    cache_jobs = WaitFeedCache.where(:url => url)
    cache_jobs.each do |job|
      JobProgress.finished job.job_id
      job.destroy
    end if cache_jobs
  end

  def self.add(url, job_id)
    WaitFeedCache.create(:url => url, :job_id => job_id)
  end
end
