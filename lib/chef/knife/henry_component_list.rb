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
        hc = load_lib(KnifeHenry.const_get(:HENRY_LIB))
        uc = load_lib(KnifeHenry.const_get(:USER_LIB))
        load_requests(hc.zip(uc).flatten.compact.sort.uniq)
      end

      def load_requests(requests)
        requests.map do |r|
          load_component(r)
        end
      end

      def load_component(component)
        file = KnifeHenry.component(component)
        data = YAML.safe_load_file(file)
        KnifeHenry::Component.new(data)
      end

      def load_lib(lib)
        path = "#{lib}/resources/components"
        Dir.glob("#{path}/*.yml").map do |file|
          File.basename(file).gsub(/\.yml$/, '')
        end
      end
    end
  end
end
