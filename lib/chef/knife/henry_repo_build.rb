require 'chef/knife'
require 'safe_yaml'

SafeYAML::OPTIONS[:suppress_warnings] = true

class Chef
  class Knife
    class HenryRepoBuild < Knife
      deps do
        require 'knife-henry/blueprint'
        require 'knife-henry/factory'
      end

      banner 'knife henry repo build REPO_YML'

      def run
        validate!
        @name_args.each do |blueprint|
          build_repo(blueprint)
        end
      end

      private

      def validate!
        unless @name_args.size >= 1
          ui.fatal 'You must specify a repo blueprint.'
          show_usage
          exit 1
        end
      end

      def build_repo(blueprint_file)
        if File.exist?(blueprint_file)
          ui.info "Loading blueprint: #{blueprint_file}"
          blueprint = YAML.safe_load_file(blueprint_file)
          @blueprint = KnifeHenry::Blueprint.new(blueprint)
          ui.info 'Initializing factory.'
          @factory = KnifeHenry::Factory.new(@blueprint)
          ui.info "Assembling chef-solo repository: #{@blueprint.name}"
          @factory.assemble
        else
          ui.error 'Specified blueprint not found! Skipping.'
        end
      end
    end
  end
end
