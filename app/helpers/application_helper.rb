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
      page << "$('#{div}').toggle();"
      #page << "$('#{div}').highlight('slow');"
    end
  end

  def show_comment_form(div, div2)
    update_page do |page|
      page << "$('#{div}').slideToggle('fast');$('#{div2}').hide();$.scrollTo('#c_footer', 1000);"
    end
  end

  def show_comments(div, div2, div3)
    update_page do |page|
      page << "$('#{div}').slideToggle('fast');$('#{div2}').hide();$('#{div3}').show();"
    end
  end

  def hide_comments(div, div2, div3)
    update_page do |page|
      page << "$('#{div}').slideToggle('fast');$('#{div2}').show();$('#{div3}').hide();"
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

  def get_address_for?(user, a)
    begin
      if user.resolve_ips
        "#{image_tag('other/tick-circle.png', :size => '10x10')} #{Resolv.getname(a)}"
      else
        return ''
      end
    rescue Resolv::ResolvError
      "#{image_tag('other/slash.png', :size => '10x10')} Unable To Resolve Address."
    rescue => e
      "#{image_tag('other/slash.png', :size => '10x10')} Snorby Needs To be Restarted. #{e}"
    end
  end

  def get_address_for_pdf?(a)
    begin
      "#{Resolv.getname(a)}"
    rescue Resolv::ResolvError
      "Unable To Resolve Address."
    rescue => e
      "Snorby Needs To be Restarted."
    end
  end

  def get_address_for_dash?(a)
    begin
      if user.resolve_ips
        "#{Resolv.getname(a)}"
      else
        return a
      end
    rescue Resolv::ResolvError
      "#{a}"
    rescue => e
      "#{a}"
    end
  end

  def box(msg, *links)
    sidebox_html = <<-EOF
    <div id='sidebox'>
    <ul id='sidebox_menu'>
    <span class='loading' style='display:none;'>#{image_tag('icons/sidebox_loading.gif')}</span>
    EOF
    unless links.nil?
      x = 0
      links.each do |link|
        sidebox_html += <<-EOF
        <li class='sidebox_list_item_#{x+=1}'>#{link}</li>
        EOF
      end
    end
    sidebox_html += <<-EOF
    </ul>
    <span class='sidebox_title'>#{msg}</span>
    <div id='left_corner'></div>
    <div id='right_corner'></div>
    </div>
    EOF
    return sidebox_html
  end

  def box_header(title,&block)
    if block_given?
      box_header = <<-EOF
      <div id="box_header">
        <div id="box_header_inside">
      EOF
      box_footer = <<-EOF
        </div>
      </div>
      EOF
      concat(box_header + capture(&block) + "<h1>#{title}</h1>" + box_footer, block.binding)
    else
      box_header = <<-EOF
      <div id="box_header">
      <div id="box_header_inside">
      <h1>
      #{title}
      </h1>
      </div>
      </div>
      EOF
      return box_header
    end
  end

end
