class EntryRssJob < Struct.new(:rss_url, :entry_id, :user_id)
  def perform
    require 'open-uri'
    require 'rss'
    content = ""
    begin
      open(rss_url) do |s| content = s.read.force_encoding("UTF-8") end
    rescue OpenURI::HTTPError => the_error
      puts "Got a HTTP erro #{the_error.message} on #{url}"
    end
    rss = RSS::Parser.parse content
    complete_entry rss
  end

  def complete_entry(rss)
    url = rss.channel.link
    title = rss.channel.title
    desc = rss.channel.description
    # reset the user last posts update time
    # User.update(user_id, :posts_update_at => Time.utc(1986)) # not work ??
    User.find(user_id).update_attribute(:posts_update_at, Time.utc(1986))
    Entry.update(entry_id, :url => url, :title => title, :description => desc,
                 :completed => 1, :tag => "blog")
  end

  def self.schedule(rss_url, entry_id, user_id)
    Delayed::Job.enqueue EntryRssJob.new(rss_url.downcase, entry_id, user_id)
  end
end

