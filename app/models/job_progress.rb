class JobProgress < ActiveRecord::Base
  def self.add(sum)
    JobProgress.create(:sum => sum).id
  end

  def self.remove(id)
    jobs = JobProgress.find id
    jobs.destroy if jobs
  end

  def self.finished(id)
    return if id < 0
    begin
      jobs = JobProgress.find id
    rescue 
      return 
    end
    if jobs 
      jobs.finished += 1
      jobs.save
    end
  end

  def self.all_done?(id)
    jobs = JobProgress.find id
    return true if jobs.finished >= jobs.sum
    false
  end

  def self.failed(id)
    finished id
  end
end
