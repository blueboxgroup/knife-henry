require 'knife-henry/component'
require 'knife-henry'

module KnifeHenry
  class Role
    attr_accessor :name, :components

    def initialize (opts = {})
      validate!(opts)
      @name = opts['name']
      @components = Array.new
      unless opts['components'].is_a?(Array)
        opts['components'] = Array.new
      end
      opts['components'].each do |c|
        component = YAML.safe_load_file( KnifeHenry.component(c) )
        @components << KnifeHenry::Component.new(component)
      end
    end

    def render (context = {})
      validate_context!(context)
      self.components.each do |component|
        component.render(context)
      end
      src = File.read(KnifeHenry.resource("role.rb.erb"))
      template = Erubis::Eruby.new(src)
      file = File.join(context[:repo], "roles", "#{self.name}.rb")
      File.open(file, 'w') { |role|
        role.write( template.evaluate({ :name       => self.name,
                                        :components => self.components}) )
      }
    end

    def berks
      berks = Array.new
      self.components.each do |component|
        berks << component.berks.split(/\r?\n/) if component.berks
      end
      return berks.flatten
    end

    private
    def validate! (opts)
      unless opts['name']
        raise ArgumentError, "Missing required argument for role: name"
      end
    end

    def validate_context! (context)
      repo = File.expand_path(context[:repo])
      cookbook = File.join(repo, "site-cookbooks", context[:cookbook])
      if !Dir.exist?(repo)
        raise ArgumentError, "Repo not found: #{context[:repo]}"
      elsif !Dir.exist?(cookbook)
        raise ArgumentError, "Site cookbook not found: #{context[:cookbook]}"
      end
    end
  end
end
