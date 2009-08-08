class ReportSweeper < ActionController::Caching::Sweeper
  observe Report
  
  def after_save(report)
    expire_cache(report)
  end
  
  def after_delete_multiple(report)
    expire_cache(report)
  end
  
  def after_destroy(report)
    expire_cache(report)
  end
  
  def expire_cache(report)
    expire_action :controller => 'Reports', :action => 'index'
  end
  
end