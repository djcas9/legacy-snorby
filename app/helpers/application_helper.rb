# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  ## Sensor
  def events_for_sensor(s)
    c = Event.find(:all, :conditions => ['sid = ?', s.id]).size + 0
    return "#{pluralize(c, 'event')}"
  end
  
  def events_for_sensor_only(s)
    Event.find(:all, :conditions => ['sid = ?', s.id]).size
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

  ## Severity
  def severity_image(s)
    if s == 1
      "#{image_tag('severity/high.png')}"
    elsif s == 2
      "#{image_tag('severity/warn.png')}"
    else
      "#{image_tag('severity/low.png')}"
    end
  end
  ## END

  def no_data
    "<tr><td><span id='no_data_holder'>#{image_tag('no_data.png', :size=>'12x12', :id=>'no_data')} No Data Available!</font></td></tr>"
  end

  def toggle_div(div)
    update_page do |page|
      page[div].toggle
      page[div].visual_effect :highlight
    end
  end
  
  def show_comment_form(div)
    update_page do |page|
      page[div].toggle
    end
  end
  
  def show_comments(div)
    update_page do |page|
      page[div].toggle
      #page[div].visual_effect :highlight
    end
  end

  def fade_div(div)
    update_page do |page|
      page[div].visual_effect :fade, :duration => 0.6
      flash.discard
    end
  end
  
  def appear_div(div)
    update_page do |page|
      page[div].visual_effect :fade, :duration => 0.6
      flash.discard
    end
  end
  
  def link_for_event_importance(event)
    if event.importance
    	"#{link_to_remote "#{image_tag('other/is_important.png', :size => '12x12')}", :update => "event_options_#{event.id}", :url => { :controller => 'events', :action => "important", :id => event }, :html => { :title => "Make This Event NOT Important" }}"
    else
    	"#{link_to_remote "#{image_tag('other/is_not_important.png', :size => '12x12')}", :update => "event_options_#{event.id}", :url => { :controller => 'events', :action => "important", :id => event }, :html => { :title => "Make This Event Important" }}"
    end
  end

  def total_event_count_for?(event)
    Event.find_all_by_signature(event.signature).length
  end

  def get_address_for?(a)
    begin
      "#{image_tag('other/tick-circle.png', :size => '10x10')} #{Resolv.getname(a)}"
    rescue Resolv::ResolvError
      "#{image_tag('other/slash.png', :size => '10x10')} Unable To Resolve Address."
    rescue => e
      "#{image_tag('other/slash.png', :size => '10x10')} Snorbby Needs To be Restarted."
    end
  end
  
  def get_address_for_pdf?(a)
    begin
      "#{Resolv.getname(a)}"
    rescue Resolv::ResolvError
      "Unable To Resolve Address."
    rescue => e
      "Snorbby Needs To be Restarted."
    end
  end
  
  
  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="12"
              id="clippy" >
      <param name="movie" value="/flash/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param NAME="FlashVars" value="text=#{text}">
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/flash/clippy.swf"
             width="110"
             height="12"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars="text=#{text}"
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
  end

end
