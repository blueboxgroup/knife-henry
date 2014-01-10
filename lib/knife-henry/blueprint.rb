require 'knife-henry/role'

module KnifeHenry
  class Blueprint
    attr_accessor :name, :roles, :vars

    def initialize (blueprint = {})
      validate!(blueprint)
      @name = blueprint['name'].to_s
      @roles = build_roles(blueprint['roles'])
      @vars = blueprint['vars'] || {}
      embed_vars
    end

    def render; end

    private

    def validate! (blueprint)
      unless blueprint['name']
        raise ArgumentError, "Blueprint missing required argument: name"
      end
    end

    def build_roles (r)
      roles = []
      r.each_pair do |name, components|
        roles << KnifeHenry::Role.new('name'       => name,
                                      'components' => components)
      end
      return roles
    end

    def embed_vars
      roles.each do |role|
        role.components.each do |component|
          component.vars = vars[component.name]
        end
      end
    end
  end
end
