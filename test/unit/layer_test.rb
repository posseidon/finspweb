require 'test/unit'
require './lib/common/layer'

class LayerTest < Test::Unit::TestCase
  def test_init
    layer = Layer.new('Foldreszlet', 40)
    assert_not_nil(layer)
  end

  def test_extract_attr
    str = 'jelkulcs, :integer'
    attribute = Layer.extract_attribute(str)
    assert_equal({"jelkulcs" => "integer"}, attribute)
  end

  def test_add_attribute
    layer = Layer.new('Foldreszlet', 500)
    str = 'jelkulcs, :integer'
    attribute = Layer.extract_attribute(str)
    layer.add_attribute(attribute)
    assert_equal([{"jelkulcs" => "integer"}],layer.attributes)
  end

  def test_to_json
    layer = Layer.new('Foldreszlet', 500)
    str = 'jelkulcs, :integer'
    str2 = 'meretarany, :string'
    attr = Layer.extract_attribute(str)
    attr2 = Layer.extract_attribute(str2)
    layer.add_attribute(attr)
    layer.add_attribute(attr2)
    object = JSON.parse(layer.to_json)
    assert_equal(object['attributes'][0], {"jelkulcs" => "integer"})
  end
end