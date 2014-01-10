require 'minitest/autorun'
require_relative '../lib/knife-henry/factory'

class TestFactory < Minitest::Test
  TEST_BLUEPRINT = {
    'name' => 'blueprint',
    'roles' => { 'test' => ["base"] },
    'vars' => { 'base' => { 'users' => ['admin', 'deploy'] } }
  }

  def setup
    @blueprint = KnifeHenry::Blueprint.new(TEST_BLUEPRINT)
    @factory = KnifeHenry::Factory.new(@blueprint)
  end

  def test_responds_to_blueprint
    assert_respond_to @factory, :blueprint
  end

  def test_sets_proper_blueprint
    assert_instance_of KnifeHenry::Blueprint, @factory.blueprint
  end

  def test_responds_to_solo
    assert_respond_to @factory, :solo
  end

  def test_sets_proper_solo
    assert_instance_of Chef::Knife::SoloInit, @factory.solo
  end

  def test_responds_to_cookbook
    assert_respond_to @factory, :cookbook
  end

  def test_sets_proper_cookbook
    assert_instance_of Chef::Knife::CookbookCreate, @factory.cookbook
  end

  def test_responds_to_assemble
    assert_respond_to @factory, :assemble
  end
end
