module KnifeHenry
  def self.version
    '0.1.1'
  end

  def self.prerelease?
    Gem::Version.new(self.version).prerelease?
  end

  def self.post_install_message
    <<-TXT.gsub(/^ {6}/, '').strip
      Thanks for installing knife-henry!

      Help us make knife-henry better by reporting issues at:
        https://github.com/blueboxgroup/knife-henry/issues
    TXT
  end
end
