class ProcessJob < ActiveRecord::Base
  def self.exist?(url)
    not ProcessJob.find_by_url(url).nil?
  end

  def self.add(url)
    ProcessJob.create(:url => url)
  end

  def self.remove(url)
    job = ProcessJob.find_by_url url
    job.destroy unless job.nil?
  end
end
