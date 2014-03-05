require 'chef/knife'

class Chef
  class Knife
    class HenryBlueprintCreate < Knife
      deps do
        require 'knife-henry'
        require 'erubis'
      end

      banner 'knife henry blueprint create REPO, ...'

      def run
        validate!
        @name_args.each do |repo|
          next unless validate_blueprint!(repo)
          render_blueprint(repo)
        end
      end

      private

      def validate!
        unless @name_args.size >= 1
          ui.fatal 'No blueprint specified.'
          show_usage
          exit 1
        end
      end

      def validate_blueprint!(repo)
        return true unless File.exist?("#{repo}.yml")
        ui.error "#{repo}.yml already exists! Skipping."
        return false
      end

      def render_blueprint(repo)
        ui.info "Rendering blueprint: #{repo}.yml"
        input = File.read(KnifeHenry.resource('blueprint.yml.erb'))
        template = Erubis::Eruby.new(input)
        File.open("#{repo}.yml", 'w') do |blueprint|
          blueprint.write(template.evaluate(:repo => repo))
        end
      end
    end
  end
end
