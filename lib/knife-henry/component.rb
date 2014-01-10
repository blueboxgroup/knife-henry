require 'knife-henry'
require 'safe_yaml'

module KnifeHenry
  class Component
    attr_accessor :name, :berks, :role, :recipe, :vars,
                  :attributes, :templates, :tests

    Template = Struct.new(:name, :content)

    def initialize(opts = {})
      validate!(opts)
      @name = opts['name']
      @berks = opts['berks']
      @role = opts['role']
      @recipe = opts['recipe']
      @vars = opts['vars'] || {}
      @attributes = opts['attributes']
      @templates = []
      opts['templates'] = [] unless opts['templates'].is_a? Array
      opts['templates'].each do |template|
        @templates << build_template(template)
      end
    end

    def render(context = {})
      validate_context!(context)
      render_role(context[:repo], context[:cookbook]) if role
      render_recipe(context[:repo], context[:cookbook]) if recipe
      render_attributes(context[:repo], context[:cookbook]) if attributes
      templates.each do |template|
        render_template(template, context)
      end
    end

    def save
      user_lib = KnifeHenry.const_get(:USER_LIB)
      f = File.join(user_lib, 'resources', 'components', "#{name}.yml")
      File.open(f, 'w') do |file|
        file.write(self.to_yaml)
      end
    end

    private

    def validate!(opts)
      unless opts['name']
        fail ArgumentError, 'Missing required parameter "name" for component.'
      end
    end

    def validate_context!(context)
      repo = File.expand_path(context[:repo])
      cookbook = File.join(repo, 'site-cookbooks', context[:cookbook])
      if !Dir.exist?(repo)
        fail ArgumentError, "Repo not found: #{context[:repo]}"
      elsif !Dir.exist?(cookbook)
        fail ArgumentError, "Site cookbook not found: #{context[:cookbook]}"
      end
    end

    def build_template(template = {})
      name, content = template.first
      Template.new(name, content)
    end

    def render_recipe(repo, cookbook)
      repo = File.expand_path(repo)
      path = File.join(repo, 'site-cookbooks', cookbook)
      File.open(File.join(path, 'recipes', "#{name}.rb"), 'w') do |recipe|
        recipe.write(recipe)
      end
    end

    def render_role(repo, cookbook)
      path = File.expand_path(repo)
      template = Erubis::Eruby.new(role)
      File.open(File.join(path, 'roles', "#{name}.rb"), 'w') do |role|
        role.write(template.evaluate(:cookbook => cookbook,
                                     :vars     => vars))
      end
    end

    def render_attributes(repo, cookbook)
      path = File.expand_path(File.join(repo, 'site-cookbooks', cookbook))
      File.open(File.join(path, 'attributes', 'default.rb'), 'a') do |attr|
        attr.write(attributes)
      end
    end

    def render_template(template, context)
      repo = File.expand_path(context[:repo])
      path = File.join(repo, 'site-cookbooks', context[:cookbook])
      out = File.join(path, 'templates', 'default', template.name)
      File.open(out, 'w') do |t|
        t.write(template.content)
      end
    end
  end
end
