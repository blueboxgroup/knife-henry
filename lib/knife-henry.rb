require 'knife-henry/info'
require 'chef/knife'

module KnifeHenry
  HENRY_LIB = File.expand_path('../knife-henry', __FILE__)
  USER_LIB = File.join(Chef::Knife.chef_config_dir, 'knife-henry')

  def self.resource (name)
    henry_resource = File.join(HENRY_LIB, 'resources', name)
    user_resource = File.join(USER_LIB, 'resources', name)
    File.exist?(user_resource) ? user_resource : henry_resource
  end

  def self.component (name)
    self.resource("components/#{name}.yml")
  end
end
