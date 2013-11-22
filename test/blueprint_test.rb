require 'minitest/autorun'
require_relative '../lib/knife-henry/blueprint'

class TestBlueprint < Minitest::Test

  TEST_BLUEPRINT = {
    'name' => 'blueprint',
    'roles' => {'test' => ["base"]},
    'vars' => { 'base' => {'users' => ['admin', 'deploy']} }
  }

  def setup
    @blueprint = KnifeHenry::Blueprint.new(TEST_BLUEPRINT)
  end

  def test_responds_to_name
    assert_respond_to @blueprint, :name
  end

  def test_sets_proper_name
    assert_instance_of String, @blueprint.name
    assert_equal 'blueprint', @blueprint.name
  end

  def test_responds_to_roles
    assert_respond_to @blueprint, :roles
  end

  def test_sets_proper_roles
    assert_instance_of Array, @blueprint.roles
    @blueprint.roles.each do |role|
      assert_instance_of KnifeHenry::Role, role
    end
  end

  def test_responds_to_vars
    assert_respond_to @blueprint, :vars
  end

  def test_sets_proper_vars
    assert_instance_of Hash, @blueprint.vars
    @blueprint.vars.each_pair do |role, vars|
      assert_equal 'base', role
      assert_instance_of Hash, vars
      vars.each_pair do |k, v|
        assert_equal 'users', k
        assert_equal ['admin', 'deploy'], v
      end
    end
  end
 
end
