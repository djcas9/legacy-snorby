require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Setting.new.valid?
  end
end
