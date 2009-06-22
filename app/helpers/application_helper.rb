# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  
  def sensor?(s)
    Sensor.find_by_sid(s.sid).hostname
  end
  
  def iphdr_info?(s)
    Iphdr.find_by_cid(s.cid)
  end
  
  def get_sig_name(s)
    Signature.find_by_sig_id(s).sig_name
  end
  
end
