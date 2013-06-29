require 'test/unit'
require './lib/common/layer'

class LayerTest < Test::Unit::TestCase
  def test_init
    layer = Layer.new('Foldreszlet', 40)
    assert_not_nil(layer)
  end
end