require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Report.new.valid?
  end
end
