require 'minitest/autorun'
require_relative '../lib/knife-henry/role'

class TestRole < Minitest::Test
  TEST_ROLE = {
    'name' => 'test',
    'components' => ['base']
  }

  def setup
    @role = KnifeHenry::Role.new(TEST_ROLE)
  end

  def test_is_a_role
    assert_instance_of KnifeHenry::Role, @role
  end

  def test_responds_to_name
    assert_respond_to @role, :name
  end

  def test_responds_to_components
    assert_respond_to @role, :components
  end

  def test_responds_to_render
    assert_respond_to @role, :render
  end

  def test_responds_to_berks
    assert_respond_to @role, :berks
  end

  def test_sets_proper_name
    assert_instance_of String, @role.name
    assert_equal 'test', @role.name
  end

  def test_has_components
    assert_instance_of Array, @role.components
    @role.components.each do |component|
      assert_instance_of KnifeHenry::Component, component
    end
  end

  def test_berks_is_array
    assert_instance_of Array, @role.berks
  end
end
