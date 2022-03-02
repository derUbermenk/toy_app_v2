require "test_helper"

class ToyTest < ActiveSupport::TestCase
  def setup
    @toy = build :toy
  end

  test 'it is valid' do
    assert @toy.valid?
  end

  test 'it needs a name' do
    @toy.name = '         '
    assert_not @toy.valid?
  end

  test 'it needs an ownder' do
    @toy.owner  = nil
    assert_not @toy.valid?
  end
end
