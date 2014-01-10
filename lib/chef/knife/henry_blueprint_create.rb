require 'chef/knife'

class Chef
  class Knife
    class HenryBlueprintCreate < Knife
      deps do
        require 'knife-henry'
        require 'erubis'
      end

      banner "knife henry blueprint create REPO, ..."

      def run
        validate!
        @name_args.each do |name|
          next unless validate_blueprint!(name)
          render_blueprint(name)
        end
      end

      private

      def validate!
        unless @name_args.size >= 1
          ui.fatal "No blueprint specified."
          show_usage
          exit 1
        end
      end

      def validate_blueprint! (name)
        if File.exist?("#{name}.yml")
          ui.error "#{name}.yml already exists! Skipping."
          return false
        end
        return true
      end

      def render_blueprint (name)
        ui.info "Rendering blueprint: #{name}.yml"
        input = File.read(KnifeHenry.resource("blueprint.yml.erb"))
        template = Erubis::Eruby.new(input)
        File.open("#{name}.yml", 'w') do |blueprint|	
          blueprint.write( template.evaluate(:name => name) )
        end
      end
    end
  end
end
