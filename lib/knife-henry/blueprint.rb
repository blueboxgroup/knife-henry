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

    def render

    end
    private
    def validate! (blueprint)
      unless blueprint['name']
        raise ArgumentError, "Blueprint missing required argument: name"
      end
    end

    def build_roles (r)
      roles = Array.new
      r.each_pair { |name, components|
        roles << KnifeHenry::Role.new({ 'name'       => name,
                                        'components' => components })
      }
      return roles
    end

    def embed_vars
      self.roles.each do |role|
         role.components.each do |component|
           component.vars = self.vars[component.name]
         end
      end
    end
  end
end
