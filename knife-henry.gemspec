require File.join(File.dirname(__FILE__), 'lib', 'knife-henry', 'info')

Gem::Specification.new do |s|
  s.name         = 'knife-henry'
  s.version      = KnifeHenry.version
  s.summary      = "A factory for chef-solo repositories"
  s.description  = "A wrapper for berkshelf and knife-solo 
                    to quickly build chef-solo repositories 
                    with common infrastructures components."
  s.license      = 'Apache'
  s.authors      = ["Blue Box Group"]
  s.email        = 'chefs@bluebox.net'
  s.homepage     =
    'http://github.com/blueboxgroup/knife-henry'

  manifest        = File.readlines("Manifest.txt").map(&:chomp)
  s.files         = manifest + Dir.glob("lib/knife-henry/resources/components/*.yml")
  s.executables   = manifest.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = manifest.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.post_install_message = KnifeHenry.post_install_message

  s.add_dependency 'knife-solo', '>= 0.3.0'
  s.add_dependency 'safe_yaml',  '>= 0.9.5'
  s.add_dependency 'erubis',     '~> 2.7.0'
end
