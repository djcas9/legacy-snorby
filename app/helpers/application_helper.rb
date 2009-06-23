# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  ## Signature Data
  def get_sig_type_for?(s)
    SigClass.find(s).sig_class_name.titleize
  end
  ## END


  ## Encoding Data
  def get_encoding_for?(s)
    Encoding.find_by_encoding_type(s).encoding_text
  end
  ## END

  ## Reference Data
  def get_ref_type_for?(s)
    r_s_n = Reference.find_by_ref_id(s)
    ReferenceSystem.find_by_ref_system_id(r_s_n.ref_id).ref_system_name
  end

  def get_ref_data_for?(s)
    Reference.find_by_ref_id(s).ref_tag
  end
  ## END

end
