xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t(:rss_title)
    xml.description t(:rss_description)
    xml.link micro_posts_feed_url
    for post in @micro_posts
      xml.item do
        xml.title post.title
        xml.description post.description
        xml.pubDate post.pub_date.to_s(:rfc822)
        xml.link micro_post_url(post)
        xml.guid micro_post_url(post)
      end
    end
  end
end

