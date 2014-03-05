require 'knife-henry/role'

module KnifeHenry
  class Blueprint

    attr_accessor :name, :roles, :vars

    def initialize(blueprint = {})
      validate!(blueprint)
      @name = blueprint['name'].to_s
      @roles = blueprint['roles'] || []
      @roles.map! { |role| build_role(role) }
      @vars = blueprint['vars'] || {}
      embed_vars
    end

    def render; end

    private

    def validate!(blueprint)
      unless blueprint['name']
        fail ArgumentError, 'Blueprint missing required argument: name'
      end
    end

    def build_role(r)
      KnifeHenry::Role.new('name'       => r.keys.first.to_s,
                           'components' => r.values.flatten)
    end

    def embed_vars
      @roles.each do |role|
        role.components.each do |component|
          component.vars = vars[component.name]
        end
      end
    end
  end
end
