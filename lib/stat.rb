# make a statistics for codertrace.com
# 3.1.2012
# Kevin Lynx
class Stat
  def self.base_info
    "User count: #{User.all.count}, Entry count: #{Entry.all.count}"
  end

  def self.sign_in_info
    ret = ""
    User.where("sign_in_count > 1").sort.each do |user|
      ret += "* #{user.name}, entries: #{user.entrys.count}, sign_in_count: #{user.sign_in_count}\n"
    end
    ret
  end

  def self.to_html
    s = header "Base info"
    s += p(base_info)
    s += header "sign in info"
    s += p(sign_in_info)
    Maruku.new(s).to_html
  end

  def self.header(s)
    s += "\n--------------------------------------\n\n"
  end

  def self.p(s)
    "#{s}\n"
  end
end

