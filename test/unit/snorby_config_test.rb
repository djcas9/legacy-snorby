require 'test_helper'

class SnorbyConfigTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert SnorbyConfig.new.valid?
  end
end
