require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Setting.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Setting.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Setting.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to setting_url(assigns(:setting))
  end
  
  def test_edit
    get :edit, :id => Setting.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Setting.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Setting.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Setting.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Setting.first
    assert_redirected_to setting_url(assigns(:setting))
  end
  
  def test_destroy
    setting = Setting.first
    delete :destroy, :id => setting
    assert_redirected_to settings_url
    assert !Setting.exists?(setting.id)
  end
end
