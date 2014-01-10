require 'chef/knife'

class Chef
  class Knife
    class HenryComponentLoad < Knife
      deps do
        require 'knife-henry/component'
        require 'safe_yaml'
      end

      banner "knife henry component load COMPONENT_YML, ..."

      def run
        validate!
        @name_args.each do |file|
          load_component(file)
        end
      end

      private

      def validate!
        unless @name_args.size >= 1
          ui.fatal "You must specify a component definition."
          show_usage
          exit 1
        end
      end

      def load_component (file)
        if File.exist?(file)
          ui.info "Stocking new component: #{file}"
          data = YAML.safe_load_file(file)
          component = KnifeHenry::Component.new(data)
          component.save
        else
          ui.error "Component definition #{file} not found!"
        end
      end
    end
  end
end
