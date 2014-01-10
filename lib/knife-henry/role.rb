require 'knife-henry/component'
require 'knife-henry'

module KnifeHenry
  class Role
    attr_accessor :name, :components

    def initialize(opts = {})
      validate!(opts)
      @name = opts['name']
      @components = []
      opts['components'].is_a?(Array) || opts['components'] = []
      opts['components'].each do |c|
        component = YAML.safe_load_file( KnifeHenry.component(c) )
        @components << KnifeHenry::Component.new(component)
      end
    end

    def render(context = {})
      validate_context!(context)
      components.each do |component|
        component.render(context)
      end
      src = File.read(KnifeHenry.resource("role.rb.erb"))
      template = Erubis::Eruby.new(src)
      file = File.join(context[:repo], "roles", "#{name}.rb")
      File.open(file, 'w') do |role|
        role.write( template.evaluate(:name       => name,
                                      :components => components) )
      end
    end

    def berks
      berks = []
      components.each do |component|
        berks << component.berks.split(/\r?\n/) if component.berks
      end
      return berks.flatten
    end

    private

    def validate!(opts)
      unless opts['name']
        fail ArgumentError, "Missing required argument for role: name"
      end
    end

    def validate_context!(context)
      repo = File.expand_path(context[:repo])
      cookbook = File.join(repo, "site-cookbooks", context[:cookbook])
      if !Dir.exist?(repo)
        fail ArgumentError, "Repo not found: #{context[:repo]}"
      elsif !Dir.exist?(cookbook)
        fail ArgumentError, "Site cookbook not found: #{context[:cookbook]}"
      end
    end
  end
end
