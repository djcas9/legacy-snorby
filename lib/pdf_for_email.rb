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
      if !@h.blank? and !@m.blank? and !@l.blank?
        begin
          image open(Gchart.line(:line_color => ["adffa2", "f8f9a4", "fb9c9c"], :labels => ["Low", "Medium", "High"], :data => [@l, @m, @h], :size => '500x230')), :position => :center
        rescue
          text "Error Creating Graphs.", :size => 15, :style => :bold, :align => :left
        end
      end
      move_down(30)
      xheader = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
      table [[@l_c.size, @m_c.size, @h_c.size, events.size]],
      :headers => xheader,
      :position => :center,
      :width => 500,
      :border_width => 1,
      :font_size => 12
      move_down(20)
      begin
        image open(Gchart.pie_3d(:line_color => ["adffa2", "f8f9a4", "fb9c9c"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
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
        h_header = ["Event Name", "Sensor", "Source Address", "Destination Address", "Session Count"]
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
        m_header = ["Event Name", "Sensor", "Source Address", "Destination Address", "Session Count"]
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
        l_header = ["Event Name", "Sensor", "Source Address", "Destination Address", "Session Count"]
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
end
  ### End Of Data
