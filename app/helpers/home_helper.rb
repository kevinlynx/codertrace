module HomeHelper
  def history_content
    content = ""
    File.open('public/history.txt', 'r') do |file|
        content = file.sysread(file.size)
        Common.force_utf8! content
        content = Maruku.new(content).to_html
    end
    content
  end
end
