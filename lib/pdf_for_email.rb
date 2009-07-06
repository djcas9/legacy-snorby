require 'prawn'
require 'prawn/layout'
require 'prawn/format'
require File.dirname(__FILE__) + "/../config/environment"

class Pdf_for_email


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
      snorby_logo = "public/images/PDF/snorby_logo.png"
      high_i = "public/images/PDF/high.png"
      medium_i = "public/images/PDF/medium.png"
      low_i = "public/images/PDF/low.png"
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
      text "#{report.rtype.capitalize} Security Report", :size => 25, :style => :bold, :align => :center
      text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

      move_down(30)
      start_new_page

      ###

      ### Summary
      move_down(2)
      text "#{report.rtype.capitalize} Report Summary", :size => 20, :style => :bold, :align => :center
      stroke_horizontal_rule
      move_down(50)
      @_line_data = []
      @_line_color = []
      @_line_label = []
      unless @l.blank?
        @_line_data << @l unless @l.blank?
        @_line_color << "adffa2"
        @_line_label << "Low"
      end
      unless @m.blank?
        @_line_data << @m unless @m.blank?
        @_line_color << "f8f9a4"
        @_line_label << "Medium"
      end
      unless @h.blank?
        @_line_data << @h unless @h.blank?
        @_line_color << "fb9c9c"
        @_line_label << "High"
      end
      unless events.blank?
        image open(Gchart.line(:line_color => @_line_color, :labels => @_line_label, :data => @_line_data, :size => '500x230')), :position => :center
        move_down(30)
      end
      xheader = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
      table [[@l_c.size, @m_c.size, @h_c.size, events.size]],
      :headers => xheader,
      :position => :center,
      :width => 500,
      :border_width => 1,
      :font_size => 10
      begin
        unless events.blank?
          move_down(30)
          image open(Gchart.pie_3d(:line_color => ["adffa2", "f8f9a4", "fb9c9c"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
        end
      rescue
        move_down(40)
        text "Error Creating Graphs.", :size => 15, :style => :bold, :align => :left
      end
      move_down(40)

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
        text "NO DATA", :size => 30, :style => :bold, :align => :center, :color => :red
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
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "ededed"],
        :width => 535,
        :border_width => 1,
        :font_size => 10
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
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "ededed"],
        :width => 535,
        :border_width => 1,
        :font_size => 10
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
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "ededed"],
        :width => 535,
        :border_width => 1,
        :font_size => 10
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
      snorby_logo = "public/images/PDF/snorby_logo.png"
      line_width(1)

      ### GET DATA

      ### END

      ### Start Of Cover

      move_down(100)
      image snorby_logo, :scale=>0.7, :position => :center
      text "#{event.sig.sig_name}", :size => 15, :style => :bold, :align => :center
      text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

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
      :position => :center,
      :width => 500,
      :border_width => 1,
      :font_size => 10


      move_down(25)

      text "IP Address Information:", :size => 15, :style => :bold, :align => :left
      b_header = ["Source IP", "Destination IP"]
      table [["#{IPAddr.new_ntoh([event.iphdr.ip_src].pack('N'))}", "#{IPAddr.new_ntoh([event.iphdr.ip_dst].pack('N'))}"]],
      :headers => b_header,
      :position => :center,
      :width => 500,
      :border_width => 1,
      :font_size => 10

      move_down(25)

      c_header = ["Version", "Header Length", "Type of Service", "Length", "ID", "Flags", "Offset", "TTL", "Protocol", "Check Sum"]
      table [[event.iphdr.ip_ver, event.iphdr.ip_hlen, event.iphdr.ip_tos, event.iphdr.ip_len, event.iphdr.ip_id, event.iphdr.ip_flags, event.iphdr.ip_off, event.iphdr.ip_ttl, event.iphdr.ip_proto, event.iphdr.ip_csum]],
      :headers => c_header,
      :position => :center,
      :width => 500,
      :border_width => 1,
      :font_size => 10

      unless event.tcphdr.blank?
        move_down(25)
        text "TCP Information:", :size => 15, :style => :bold, :align => :left
        d_header = ["S. Port", "D. Port", "Seq #", "Ack", "Offset", "Reset", "Flags", "Window", "Check Sum", "Urgent Pointer"]
        table [[event.tcphdr.tcp_sport, event.tcphdr.tcp_dport, event.tcphdr.tcp_seq, event.tcphdr.tcp_ack, event.tcphdr.tcp_off, event.tcphdr.tcp_res, event.tcphdr.tcp_flags, event.tcphdr.tcp_win, event.tcphdr.tcp_csum, event.tcphdr.tcp_urp]],
        :headers => d_header,
        :position => :center,
        :width => 500,
        :border_width => 1,
        :font_size => 10

        move_down(25)
      end

      unless event.udphdr.blank?
        move_down(25)

        text "UDP Information:", :size => 15, :style => :bold, :align => :left
        c_header = ["Source Port", "Destination Port", "Length", "CheckSum"]
        table [[event.udphdr.udp_sport, event.udphdr.udp_dport, event.udphdr.udp_len, event.udphdr.udp_csum]],
        :headers => c_header,
        :position => :center,
        :width => 500,
        :border_width => 1,
        :font_size => 10

        move_down(25)
      end

      unless event.icmphdr.blank?
        move_down(25)

        text "ICMP Information:", :size => 15, :style => :bold, :align => :left
        f_header = ["Type", "Code", "CheckSum", "ID", "Sequence Number"]
        table [[event.icmphdr.icmp_type, event.icmphdr.icmp_code, event.icmphdr.icmp_csum, event.icmphdr.icmp_id, event.icmphdr.icmp_seq]],
        :headers => f_header,
        :position => :center,
        :width => 500,
        :border_width => 1,
        :font_size => 10

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
      snorby_logo = "public/images/PDF/snorby_logo.png"
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
      text "Snorby Search Report", :size => 25, :style => :bold, :align => :center
      text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

      move_down(30)
      start_new_page

      ###

      ### Summary
      move_down(2)
      text "Snorby Search Report Summary", :size => 20, :style => :bold, :align => :center
      stroke_horizontal_rule
      move_down(50)
      @_line_data = []
      @_line_color = []
      @_line_label = []
      unless @l.blank?
        @_line_data << @l unless @l.blank?
        @_line_color << "adffa2"
        @_line_label << "Low"
      end
      unless @m.blank?
        @_line_data << @m unless @m.blank?
        @_line_color << "f8f9a4"
        @_line_label << "Medium"
      end
      unless @h.blank?
        @_line_data << @h unless @h.blank?
        @_line_color << "fb9c9c"
        @_line_label << "High"
      end
      
      unless search.events.blank?
        image open(Gchart.line(:line_color => @_line_color, :labels => @_line_label, :data => @_line_data, :size => '500x230')), :position => :center
        move_down(30)
      end
      
      xheader = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
      table [[@l_c.size, @m_c.size, @h_c.size, search.events.size]],
      :headers => xheader,
      :position => :center,
      :width => 500,
      :border_width => 1,
      :font_size => 10
      begin
        unless search.events.blank?
          move_down(30)
          image open(Gchart.pie_3d(:line_color => ["adffa2", "f8f9a4", "fb9c9c"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
        end
      rescue
        move_down(40)
        text "Error Creating Graphs.", :size => 15, :style => :bold, :align => :left
      end
      move_down(40)
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
        move_down(30)
        text "NO DATA", :size => 30, :style => :bold, :align => :center
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
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "ededed"],
        :width => 535,
        :border_width => 1,
        :font_size => 10
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
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "ededed"],
        :width => 535,
        :border_width => 1,
        :font_size => 10
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
        :border_style => :grid,
        :position => :center,
        :row_colors => ["FFFFFF", "ededed"],
        :width => 535,
        :border_width => 1,
        :font_size => 10
      end
    end
    ### End Of Data
  end
end
### End Of Data
