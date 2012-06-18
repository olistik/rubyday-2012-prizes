class ML
  def initialize(email)
    @email = email
    @formatted_email = @email.gsub('@', ' a ')
  end

  def posts_count
    @value ||= fetch
  end

  private
  def fetch
    archives.map {|archive| count_from_archive(archive)}.inject(:+)
  end

  def count_from_archive(archive)
    `cat #{archive} | grep -e "^From: #{@formatted_email}.*$" | wc -l`.strip.to_i
  end

  def archives
    Dir['ml-archives/**/*.txt']
  end
end
