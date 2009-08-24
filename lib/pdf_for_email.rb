require 'prawn'
require 'prawn/layout'
require 'prawn/format'
require File.dirname(__FILE__) + "/../config/environment"

class Pdf_for_email
  include ActionView::Helpers::TextHelper

  def self.count_events
    counts = Hash.new(0)
    self.events.each do |ev|
      counts["#{ev.sig.sig_name}|#{ev.iphdr.ip_src}|#{ev.iphdr.ip_dst}|#{ev.sig.sig_priority}|#{ev.sensor.sid}"] += 1
    end
    counts
  end

  def self.make_pdf(report, events)
    Prawn::Document.generate("#{RAILS_ROOT}/tmp/tmp.pdf") do

      tags :h1 => { :font_size => "2em", :font_weight => :bold },
      :h2 => { :font_size => "0.5em", :font_weight => :bold },
      :title => { :font_weight => :bold, :font_size => "1.5em" },
      :indent => { :width => "2em" },
      :event_data => { :color => 'black', :align => :justify },
      :event_title => { :color => 'black', :font_weight => :bold },
      :high => { :color => "red", :align => :left },
      :medium => { :color => 'yellow', :align => :left },
      :low => { :color => 'green', :align => :left }
      snorby_logo = "#{RAILS_ROOT}/public/images/PDF/snorby_logo.png"
      line_width(1)

      ### GET DATA
      @h_c = []
      @h = []
      @m_c = []
      @m = []
      @l_c = []
      @l = []

      report.count_events.each do |event, count|
        r = event.split('|')
        sig_name = r[0]
        src_ip = IPAddr.new_ntoh([r[1].to_i].pack('N'))
        dest_ip = IPAddr.new_ntoh([r[2].to_i].pack('N'))
        severity = r[3].to_i
        sensor = r[4].to_i
        @h_c << [count, sig_name, src_ip, dest_ip, severity, sensor] if severity == 1
        @h << count if severity == 1
        @m_c << [count, sig_name, src_ip, dest_ip, severity, sensor] if severity == 2
        @m << count if severity == 2
        @l_c << [count, sig_name, src_ip, dest_ip, severity, sensor] if severity == 3
        @l << count if severity == 3
      end
      ### END

      ### Start Of Cover

      move_down(100)
      image snorby_logo, :scale=>0.7, :position => :center
      text "#{report.rtype.capitalize} Security Report", :size => 15, :style => :bold, :align => :center
      text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :align => :center
      text "Device: #{Setting.device_name}", :size => 12, :align => :center

      move_down(30)
      start_new_page

      ###

      ### Summary
      text "#{report.rtype.capitalize} Report Summary", :size => 20, :style => :bold, :align => :center
      stroke_horizontal_rule
      move_down(25)

      text "Event Severity Summary", :size => 15, :style => :bold, :align => :center
      move_down(5)
      xheader = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
      table [[@l_c.size, @m_c.size, @h_c.size, events.size]],
      :headers => xheader,
      :header_color => 'f8f8f8',
      :header_text_color => "323233",
      :padding => 5,
      :border_style => :grid,
      :position => :center,
      :row_colors => ["FFFFFF", "e8f9ff"],
      :width => 535,
      :border_width => 1,
      :font_size => 9

      @_line_data = []
      @_line_color = []
      @_line_label = []
      unless @l.blank?
        @_line_data << @l unless @l.blank?
        @_line_color << "00ff28"
        @_line_label << "Low"
      end
      unless @m.blank?
        @_line_data << @m unless @m.blank?
        @_line_color << "ffac00"
        @_line_label << "Medium"
      end
      unless @h.blank?
        @_line_data << @h unless @h.blank?
        @_line_color << "ff3715"
        @_line_label << "High"
      end

      unless events.blank?
        move_down(15)
        text "Event Severity vs Time", :size => 15, :style => :bold, :align => :center
        text "This line graph below describes events separated by time. Abnormal events and/or unexpected spikes in the number of events should be researched further.", :size => 9
        move_down(15)
        
        if report.rtype == 'daily'
          image open(Event.activity_since(Time.parse(report.from_time), :end_time => DateTime.parse(report.to_time)).to_activity_gchart(:bgcolor => "FFFFFF", :size => "500x150", :type => :line, :lbs => "0:|#{DateTime.parse(report.from_time).strftime('%A, %B %d, %Y')}|#{DateTime.parse(report.to_time).strftime('%A, %B %d, %Y')}"))
        elsif report.rtype == 'weekly'
          image open(Event.activity_since(Time.parse(report.from_time), :end_time => DateTime.parse(report.to_time)).to_activity_gchart(:bgcolor => "FFFFFF", :size => "500x150", :type => :line, :lbs => "0:|#{DateTime.parse(report.from_time).strftime('%A, %B %d, %Y')}|#{DateTime.parse(report.to_time).strftime('%A, %B %d, %Y')}"))
        elsif report.rtype == 'monthly'
          image open(Event.activity_since(Time.parse(report.from_time), :end_time => DateTime.parse(report.to_time)).to_activity_gchart(:bgcolor => "FFFFFF", :size => "500x150", :type => :line, :lbs => "0:|#{DateTime.parse(report.from_time).strftime('%A, %B %d, %Y')}|#{DateTime.parse(report.to_time).strftime('%A, %B %d, %Y')}"))
        else
          text "Error"
        end
        
        #:group_by => :hour
        #image open(Event.activity_since(4.week.ago).to_activity_gchart(:bgcolor => "FFFFFF", :size => "500x150", :type => :line))
        move_down(5)
      end
      unless events.blank?
        move_down(20)
        text "Event Severity vs Event Count", :size => 15, :style => :bold, :align => :center
        text "Outlined by this pie chart, it displays a comparison of the severity level in an executive format of events received. Typically, a large number of high-severity events is a cause for concern and warrants an investigation.", :size => 9
        move_down(20)
        image open(Gchart.pie(:line_color => ["00ff28", "ffac00", "ff3715"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
      end
      move_down(30)

      start_new_page

      ### END

      header [margin_box.left, margin_box.top + 20] do
        text "- #{Time.now.strftime('%A, %B %d, %Y')} - Snorby Report. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
        move_down 2
        stroke_horizontal_rule
        move_down 30
      end

      footer [margin_box.left, margin_box.bottom + 5] do
        move_down 7
        stroke_horizontal_rule
        move_down 3
        text "- #{page_count} -", :size => 7, :align => :center
        move_down 1
        text "Copyright (c) Snorby.org", :size => 7, :align => :center, :style => :italic, :color => 'black'
      end

      ### Start Of Data


      if events.blank?
        move_down 30
        text "No Data was recorded for this report. Make sure snorby is collecting data from snort properly.", :size => 30, :style => :bold, :align => :center, :color => :red
      else
        move_down 10
        text "Events listed below are categorized by severity levels. Common events have been placed into sessions for easy review.", :size => 8, :align => :center, :style => :italic
      end


      unless @h_c.blank?
        move_down(20)
        text "High Severity", :size => 20, :style => :bold, :align => :left
        h = 0
        @h_t_data = Array.new
        move_down(10)
        @h_c.each do |event|
          h += 1
          @h_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
        end
        h_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
        table @h_t_data,
        :headers => h_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9
      end

      unless @m_c.blank?
        move_down(20)
        text "Medium Severity", :size => 20, :style => :bold, :align => :left
        m = 0
        @m_t_data = Array.new
        move_down(10)
        @m_c.each do |event|
          m += 1
          @m_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
        end
        m_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
        table @m_t_data,
        :headers => m_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9
      end

      unless @l_c.blank?
        move_down(20)
        text "Low Severity", :size => 20, :style => :bold, :align => :left
        h = 0
        @l_t_data = Array.new
        move_down(10)
        @l_c.each do |event|
          h += 1
          @l_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
        end
        l_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
        table @l_t_data,
        :headers => l_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9
      end

    end

  end

  def self.make_pdf_for_event(event)

    Prawn::Document.generate("#{RAILS_ROOT}/tmp/tmp-event.pdf") do

      tags :h1 => { :font_size => "2em", :font_weight => :bold },
      :h2 => { :font_size => "0.5em", :font_weight => :bold },
      :title => { :font_weight => :bold, :font_size => "1.5em" },
      :indent => { :width => "2em" },
      :event_data => { :color => 'black', :align => :justify },
      :event_title => { :color => 'black', :font_weight => :bold },
      :high => { :color => "red", :align => :left },
      :medium => { :color => 'yellow', :align => :left },
      :low => { :color => 'green', :align => :left }
      snorby_logo = "#{RAILS_ROOT}/public/images/PDF/snorby_logo.png"
      line_width(1)

      ### GET DATA

      ### END

      ### Start Of Cover

      move_down(100)
      image snorby_logo, :scale=>0.7, :position => :center
      text "#{event.sig.sig_name}", :size => 15, :style => :bold, :align => :center
      text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :align => :center
      text "Device: #{Setting.device_name}", :size => 12, :align => :center

      move_down(30)
      start_new_page

      ###



      ### END

      ### Start Of Data
      header [margin_box.left, margin_box.top + 20] do
        text "- #{Time.now.strftime('%A, %B %d, %Y')} - #{event.sig.sig_name}. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
        move_down 2
        stroke_horizontal_rule
        move_down 30
      end

      footer [margin_box.left, margin_box.bottom + 5] do
        move_down 7
        stroke_horizontal_rule
        move_down 3
        text "- #{page_count} -", :size => 7, :align => :center
        move_down 1
        text "Copyright (c) Snorby.org", :size => 7, :align => :center, :style => :italic, :color => 'black'
      end

      if event.blank?
        move_down(30)
        text "NO DATA", :size => 30, :style => :bold, :align => :center
      end

      move_down(30)
      text "#{event.sig.sig_name}", :size => 25, :style => :bold, :align => :left
      move_down(10)
      text "Sensor Information:", :size => 15, :style => :bold, :align => :left
      a_header = ["Sensor", "Interface", "Hostname", "Event ID"]
      table [[event.sensor.id, event.sensor.interface, event.sensor.hostname, event.id[1]]],
      :headers => a_header,
      :header_color => 'f8f8f8',
      :header_text_color => "323233",
      :padding => 5,
      :border_style => :grid,
      :position => :center,
      :row_colors => ["FFFFFF", "e8f9ff"],
      :width => 535,
      :border_width => 1,
      :font_size => 9


      move_down(25)

      text "IP Address Information:", :size => 15, :style => :bold, :align => :left
      b_header = ["Source IP", "Destination IP"]
      table [["#{IPAddr.new_ntoh([event.iphdr.ip_src].pack('N'))}", "#{IPAddr.new_ntoh([event.iphdr.ip_dst].pack('N'))}"]],
      :headers => b_header,
      :header_color => 'f8f8f8',
      :header_text_color => "323233",
      :padding => 5,
      :border_style => :grid,
      :position => :center,
      :row_colors => ["FFFFFF", "e8f9ff"],
      :width => 535,
      :border_width => 1,
      :font_size => 9

      move_down(25)

      c_header = ["Version", "Header Length", "Type of Service", "Length", "ID", "Flags", "Offset", "TTL", "Protocol", "Check Sum"]
      table [[event.iphdr.ip_ver, event.iphdr.ip_hlen, event.iphdr.ip_tos, event.iphdr.ip_len, event.iphdr.ip_id, event.iphdr.ip_flags, event.iphdr.ip_off, event.iphdr.ip_ttl, event.iphdr.ip_proto, event.iphdr.ip_csum]],
      :headers => c_header,
      :header_color => 'f8f8f8',
      :header_text_color => "323233",
      :padding => 5,
      :border_style => :grid,
      :position => :center,
      :row_colors => ["FFFFFF", "e8f9ff"],
      :width => 535,
      :border_width => 1,
      :font_size => 9

      unless event.tcphdr.blank?
        move_down(25)
        text "TCP Information:", :size => 15, :style => :bold, :align => :left
        d_header = ["S. Port", "D. Port", "Seq #", "Ack", "Offset", "Reset", "Flags", "Window", "Check Sum", "Urgent Pointer"]
        table [[event.tcphdr.tcp_sport, event.tcphdr.tcp_dport, event.tcphdr.tcp_seq, event.tcphdr.tcp_ack, event.tcphdr.tcp_off, event.tcphdr.tcp_res, event.tcphdr.tcp_flags, event.tcphdr.tcp_win, event.tcphdr.tcp_csum, event.tcphdr.tcp_urp]],
        :headers => d_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9

        move_down(25)
      end

      unless event.udphdr.blank?
        move_down(25)

        text "UDP Information:", :size => 15, :style => :bold, :align => :left
        c_header = ["Source Port", "Destination Port", "Length", "CheckSum"]
        table [[event.udphdr.udp_sport, event.udphdr.udp_dport, event.udphdr.udp_len, event.udphdr.udp_csum]],
        :headers => c_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9

        move_down(25)
      end

      unless event.icmphdr.blank?
        move_down(25)

        text "ICMP Information:", :size => 15, :style => :bold, :align => :left
        f_header = ["Type", "Code", "CheckSum", "ID", "Sequence Number"]
        table [[event.icmphdr.icmp_type, event.icmphdr.icmp_code, event.icmphdr.icmp_csum, event.icmphdr.icmp_id, event.icmphdr.icmp_seq]],
        :headers => f_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9

        move_down(25)
      end

      move_down(25)

      ### End Of Data
    end
  end

  def self.make_pdf_for_search(search)

    Prawn::Document.generate("#{RAILS_ROOT}/tmp/tmp-search.pdf") do

      tags :h1 => { :font_size => "2em", :font_weight => :bold },
      :h2 => { :font_size => "0.5em", :font_weight => :bold },
      :title => { :font_weight => :bold, :font_size => "1.5em" },
      :indent => { :width => "2em" },
      :event_data => { :color => 'black', :align => :justify },
      :event_title => { :color => 'black', :font_weight => :bold },
      :high => { :color => "red", :align => :left },
      :medium => { :color => 'yellow', :align => :left },
      :low => { :color => 'green', :align => :left }
      snorby_logo = "#{RAILS_ROOT}/public/images/PDF/snorby_logo.png"
      line_width(1)

      ### GET DATA
      @h_c = []
      @h = []
      @m_c = []
      @m = []
      @l_c = []
      @l = []

      search.count_events.each do |event, count|
        r = event.split('|')
        sig_name = r[0]
        src_ip = IPAddr.new_ntoh([r[1].to_i].pack('N'))
        dest_ip = IPAddr.new_ntoh([r[2].to_i].pack('N'))
        severity = r[3].to_i
        sensor = r[4].to_i
        @h_c << [count, sig_name, src_ip, dest_ip, severity, sensor] if severity == 1
        @h << count if severity == 1
        @m_c << [count, sig_name, src_ip, dest_ip, severity, sensor] if severity == 2
        @m << count if severity == 2
        @l_c << [count, sig_name, src_ip, dest_ip, severity, sensor] if severity == 3
        @l << count if severity == 3
      end
      ### END

      ### Start Of Cover

      move_down(100)
      image snorby_logo, :scale=>0.7, :position => :center
      text "Security Search Report", :size => 15, :style => :bold, :align => :center
      text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :align => :center
      text "Device: #{Setting.device_name}", :size => 12, :align => :center

      move_down(30)
      start_new_page

      ###

      ### Summary
      text "Security Search Report Summary", :size => 20, :style => :bold, :align => :center
      stroke_horizontal_rule
      move_down(25)

      text "Event Severity Summary", :size => 15, :style => :bold, :align => :center
      move_down(5)
      xheader = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
      table [[@l_c.size, @m_c.size, @h_c.size, search.events.size]],
      :headers => xheader,
      :header_color => 'f8f8f8',
      :header_text_color => "323233",
      :padding => 5,
      :border_style => :grid,
      :position => :center,
      :row_colors => ["FFFFFF", "e8f9ff"],
      :width => 535,
      :border_width => 1,
      :font_size => 9

      @_line_data = []
      @_line_color = []
      @_line_label = []
      unless @l.blank?
        @_line_data << @l unless @l.blank?
        @_line_color << "00ff28"
        @_line_label << "Low"
      end
      unless @m.blank?
        @_line_data << @m unless @m.blank?
        @_line_color << "ffac00"
        @_line_label << "Medium"
      end
      unless @h.blank?
        @_line_data << @h unless @h.blank?
        @_line_color << "ff3715"
        @_line_label << "High"
      end

      unless search.events.blank?
        move_down(45)
        text "Event Severity vs Event Count", :size => 15, :style => :bold, :align => :center
        text "Outlined by this pie chart, it displays a comparison of the severity level in an executive format of events received. Typically, a large number of high-severity events is a cause for concern and warrants an investigation.", :size => 9
        move_down(20)
        image open(Gchart.pie(:line_color => ["00ff28", "ffac00", "ff3715"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
      end
      move_down(30)

      start_new_page
      ### END

      ### Start Of Data
      header [margin_box.left, margin_box.top + 20] do
        text "- #{Time.now.strftime('%A, %B %d, %Y')} - Snorby Search Report. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
        move_down 2
        stroke_horizontal_rule
        move_down 30
      end

      footer [margin_box.left, margin_box.bottom + 5] do
        move_down 7
        stroke_horizontal_rule
        move_down 3
        text "- #{page_count} -", :size => 7, :align => :center
        move_down 1
        text "Copyright (c) Snorby.org", :size => 7, :align => :center, :style => :italic, :color => 'black'
      end

      if search.events.blank?
        text "NO DATA", :size => 30, :style => :bold, :align => :center, :color => :red
      else
        move_down 10
        text "Events listed below are categorized by severity levels. Common events have been placed into sessions for easy review.", :size => 8, :align => :center, :style => :italic
      end

      unless @h_c.blank?
        move_down(20)
        text "High Severity", :size => 20, :style => :bold, :align => :left
        h = 0
        @h_t_data = Array.new
        move_down(10)
        @h_c.each do |event|
          h += 1
          @h_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
        end
        h_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
        table @h_t_data,
        :headers => h_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9
      end

      unless @m_c.blank?
        move_down(20)
        text "Medium Severity", :size => 20, :style => :bold, :align => :left
        m = 0
        @m_t_data = Array.new
        move_down(10)
        @m_c.each do |event|
          m += 1
          @m_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
        end
        m_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
        table @m_t_data,
        :headers => m_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9
      end

      unless @l_c.blank?
        move_down(20)
        text "Low Severity", :size => 20, :style => :bold, :align => :left
        h = 0
        @l_t_data = Array.new
        move_down(10)
        @l_c.each do |event|
          h += 1
          @l_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
        end
        l_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
        table @l_t_data,
        :headers => l_header,
        :header_color => 'f8f8f8',
        :header_text_color => "323233",
        :padding => 5,
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "e8f9ff"],
        :width => 535,
        :border_width => 1,
        :font_size => 9
      end
    end
    ### End Of Data
  end
end
### End Of Data
