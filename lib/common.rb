class Common
  def self.force_utf8!(s)
    s.encode!('UTF-16BE', 'UTF-8', :invalid => :replace, :replace => '')
    s.encode!('UTF-8', 'UTF-16BE')
  end
end
