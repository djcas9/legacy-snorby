ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  if html_tag =~ /type="hidden"/ || html_tag =~ /<label/
    html_tag
  else
    "<span class='field_error'>#{html_tag}</span>" +
    "<span class='error_message'><img src='images/other/slash.png' height='16' width='16' class='on_error_icon' /> #{[instance_tag.error_message].flatten.first}</span>"
  end
end
