require 'chef/knife'

class Chef
  class Knife
    class HenryComponentList < Knife
      deps do
        require 'knife-henry'
        require 'knife-henry/component'
      end

      banner 'knife henry component list [COMPONENT, ...]'

      def run
        ui.info 'Loading component library...'
        if @name_args.empty?
          @components = load_libs
        else
          @components = load_requests(@name_args)
        end
        @components.each do |component|
          ui.msg component.name
        end
      end

      private

      def load_libs
        henry_components = load_lib(KnifeHenry.const_get(:HENRY_LIB))
        user_components = load_lib(KnifeHenry.const_get(:USER_LIB))
        load_requests(henry_components.concat(user_components).sort.uniq)
      end

      def load_requests(requests = [])
        components = []
        requests.each do |request|
          components << load_component(request)
        end
      end

      def load_component(component)
        file = KnifeHenry.component(component)
        data = YAML.safe_load_file(file)
        KnifeHenry::Component.new(data)
      end

      def load_lib(lib)
        components = []
        path = "#{lib}/resources/components"
        if Dir.exist?(path)
          Dir.glob("#{path}/*.yml") do |file|
            components << File.basename(file).gsub(/\.yml$/, '')
          end
        end
      end
    end
  end
end
