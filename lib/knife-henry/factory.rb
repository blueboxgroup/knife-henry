require 'chef/knife/solo_init'
require 'chef/knife/cookbook_create'
require 'knife-henry/component'
require 'knife-henry'
require 'fileutils'
require 'erubis'

module KnifeHenry
  class Factory
    attr_accessor :blueprint, :solo, :cookbook

    def initialize (blueprint)
      @blueprint = blueprint
      Chef::Knife::SoloInit.load_deps
      @solo = Chef::Knife::SoloInit.new
      @solo.name_args = [ @blueprint.name ]
      @cookbook = Chef::Knife::CookbookCreate.new
      @cookbook.config[:cookbook_path] = "#{@blueprint.name}/site-cookbooks"
      @cookbook.name_args = [ @blueprint.name ]
      validate!
    end

    def assemble
      self.solo.run
      self.cookbook.run
      render_toplevel_files
      berks = []
      self.blueprint.roles.each do |role|
        berks << role.berks
        role.render(:repo     => self.solo.name_args.first,
                    :cookbook => self.cookbook.name_args.first)
      end
      render_berksfile(berks.flatten)
      render_kitchen_yml
    end

    private

    def validate!
      repo = self.solo.name_args.first
      raise ArgumentError, "Specified repo already exists!" if Dir.exist?(repo)
    end

    def render_toplevel_files
      repo = self.solo.name_args.first
      %w{CHANGELOG.txt Gemfile README.md}.each do |r|
        FileUtils.cp KnifeHenry.resource(r), "#{repo}/#{r}"
      end
    end

    def render_berksfile (berks)
      repo = self.solo.name_args.first
      File.open(File.join(repo, "Berksfile"), 'w') do |berksfile|
        berksfile.write( berks.sort.uniq.join("\n") )
      end
    end

    def render_kitchen_yml
      repo = self.solo.name_args.first
      roles = self.blueprint.roles
      kitchen = File.read(KnifeHenry.resource("kitchen.yml.erb"))
      template = Erubis::Eruby.new(kitchen)
      File.open("#{repo}/.kitchen.yml", 'w') do |kitchen|
        kitchen.write( template.evaluate(:roles => roles) )
      end
    end
  end
end
