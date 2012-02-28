# require an url, not a RSS url, it will find the rss url auto.
class EntryRssJob < Struct.new(:url, :entry_id, :user_id)
  # some sites need this, otherwise the site will refuse http request
  USER_AGENT = 'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.2) Gecko/2008091700 SUSE/3.0.2-5.2 Firefox/3.0.2'

  require 'open-uri'
  require 'rss'
  require 'hpricot'

  def perform
    rss_pair = get_rss_url url
    if rss_pair.nil?
      entry_failed "get rss url failed"
    else
      rss_url = concatenate_rss_url url, rss_pair[:href]
      rss = get_rss_content rss_url
      if rss.nil?
        entry_failed "get rss content failed"
      else
        entry_done rss, rss_pair[:type], rss_url
      end
    end
  end

  def concatenate_rss_url(url, rss_href)
    rss_uri = URI.parse rss_href
    return rss_uri.to_s if rss_uri.absolute?
    uri = URI.parse url
    uri.scheme + "://" + uri.host + rss_uri.path
  end

  def get_rss_content(rss_url)
    content = ""
    begin
      open(rss_url, "User-Agent" => USER_AGENT) do 
        |s| content = s.read 
      end
      Common.force_utf8! content
    rescue OpenURI::HTTPError => the_error
    end
    rss = nil
    begin
      rss = RSS::Parser.parse content
    rescue
      nil
    end
    rss 
  end

  def get_rss_url(url)
    begin
      doc = open(url, "User-Agent" => USER_AGENT) { |f| Hpricot(f) }
      if rss = doc.at('link[@type="application/rss+xml"]')
        { :href => rss['href'].downcase.gsub('&','&amp;'), :type => :xml }
      elsif atom = doc.at('link[@type="application/atom+xml"]')
        { :href => atom['href'].downcase.gsub('&','&amp;'), :type => :atom }
      else 
        nil
      end
    rescue
      nil
    end
  end

  def entry_done(rss, type, rss_url)
    url = ""
    title = ""
    desc = ""
    if type == :atom
      url = rss.link.href
      title = rss.title.content
      desc = title
    elsif type == :xml
      url = rss.channel.link
      title = rss.channel.title
      desc = rss.channel.description
    else
      entry_failed
      return
    end
    # reset the user last posts update time
    # User.update(user_id, :posts_update_at => Time.utc(1986)) # not work ??
    User.find(user_id).update_attribute(:posts_update_at, Time.utc(1986))
    Entry.update(entry_id, :url => url, :title => title, :description => desc,
                 :completed => 1, :tag => "blog", :rss_url => rss_url)
  end

  def entry_failed(err_msg)
    Entry.update(entry_id, :url => url, :title => "", :description => err_msg, 
            :completed => -1, :tag => "", :rss_url => "")
  end

  def self.schedule(url, entry_id, user_id)
    Delayed::Job.enqueue EntryRssJob.new(url.downcase, entry_id, user_id)
  end
end

