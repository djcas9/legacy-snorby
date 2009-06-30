require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Report.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Report.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Report.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to report_url(assigns(:report))
  end
  
  def test_edit
    get :edit, :id => Report.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Report.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Report.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Report.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Report.first
    assert_redirected_to report_url(assigns(:report))
  end
  
  def test_destroy
    report = Report.first
    delete :destroy, :id => report
    assert_redirected_to reports_url
    assert !Report.exists?(report.id)
  end
end
