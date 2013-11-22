require 'chef/knife'

class Chef
  class Knife
    class HenryComponentShow < Knife
      deps do
        require 'knife-henry'
        require 'knife-henry/component'
      end

      banner "knife henry component show COMPONENT"

      def run
        validate!
        @name_args.each do |name|
          show_component(name)
        end
      end

      private
      def validate!
        unless @name_args.size >= 1
          ui.fatal "Please specify a component."
          show_usage
          exit 1
        end
      end

      def show_component (component)
        file = KnifeHenry.component(component)
        if File.exist?(file)
          data = YAML.safe_load_file(file)
          puts KnifeHenry::Component.new(data).to_yaml
        else
          ui.error "Specified component #{component} not found! Skipping."
        end
      end
    end
  end
end
