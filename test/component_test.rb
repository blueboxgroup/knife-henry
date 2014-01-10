require 'minitest/autorun'
require_relative '../lib/knife-henry/component'

class TestComponent < Minitest::Test
  TEST_COMPONENT = {
    'name' => 'component',
    'berks' => 'cookbook "test"',
    'role' => %Q{
name 'component'

default_attributes(
  'version' => '<%= @version %>'
)

run_list %w{
  recipe[test::component]
}
},
    'recipe' => %Q{
file "/tmp/component-test" do
  action :touch
end
},
    'vars' => {'version' => '1.9.3-p448'},
    'attributes' => %Q{
default['component']['attr_one'] = 1
default['component']['attr_two'] = 2
},
    'templates' => [
      { 'component.conf.erb' => 'ENABLED=yes'},
    ],
    'tests' => '',
  }

  def setup
    @component = KnifeHenry::Component.new(TEST_COMPONENT)
  end

  def test_responds_to_name
    assert_respond_to @component, :name
  end

  def test_sets_proper_name
    assert_equal 'component', @component.name
  end

  def test_responds_to_berks
    assert_respond_to @component, :berks
  end

  def test_sets_proper_berks
    assert_equal 'cookbook "test"', @component.berks
  end

  def test_responds_to_role
    assert_respond_to @component, :role
  end

  def test_responds_to_recipe
    assert_respond_to @component, :recipe
  end

  def test_responds_to_vars
    assert_respond_to @component, :vars
  end

  def test_responds_to_attributes
    assert_respond_to @component, :attributes
  end

  def test_responds_to_templates
    assert_respond_to @component, :templates
  end 

  def test_respond_to_tests
    assert_respond_to @component, :tests
  end
end
