require 'chef/knife/solo_init'
require 'chef/knife/cookbook_create'
require 'knife-henry/component'
require 'knife-henry'
require 'fileutils'
require 'erubis'

module KnifeHenry
  class Factory
    attr_accessor :blueprint, :solo, :cookbook

    def initialize(blueprint)
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
      solo.run
      cookbook.run
      render_toplevel_files
      berks = []
      blueprint.roles.each do |role|
        berks << role.berks
        role.render(:repo     => solo.name_args.first,
                    :cookbook => cookbook.name_args.first)
      end
      render_berksfile(berks.flatten)
      render_kitchen_yml
    end

    private

    def validate!
      repo = solo.name_args.first
      fail ArgumentError, "Specified repo already exists!" if Dir.exist?(repo)
    end

    def render_toplevel_files
      repo = solo.name_args.first
      %w{CHANGELOG.txt Gemfile README.md}.each do |r|
        FileUtils.cp KnifeHenry.resource(r), "#{repo}/#{r}"
      end
    end

    def render_berksfile(berks)
      repo = solo.name_args.first
      File.open(File.join(repo, "Berksfile"), 'w') do |berksfile|
        berksfile.write( berks.sort.uniq.join("\n") )
      end
    end

    def render_kitchen_yml
      repo = solo.name_args.first
      roles = blueprint.roles
      kitchen = File.read(KnifeHenry.resource("kitchen.yml.erb"))
      template = Erubis::Eruby.new(kitchen)
      File.open("#{repo}/.kitchen.yml", 'w') do |kitchen|
        kitchen.write( template.evaluate(:roles => roles) )
      end
    end
  end
end
