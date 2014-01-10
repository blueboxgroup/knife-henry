module KnifeHenry
  def version
    '0.1.1'
  end

  def prerelease?
    Gem::Version.new(version).prerelease?
  end

  def post_install_message
    <<-TXT.gsub(/^ {6}/, '').strip
      Thanks for installing knife-henry!

      Help us make knife-henry better by reporting issues at:
        https://github.com/blueboxgroup/knife-henry/issues
    TXT
  end
end
