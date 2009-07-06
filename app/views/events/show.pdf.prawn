require 'prawn/layout'
require 'prawn/format'

pdf.tags :h1 => { :font_size => "2em", :font_weight => :bold },
:h2 => { :font_size => "0.5em", :font_weight => :bold },
:title => { :font_weight => :bold, :font_size => "1.5em" },
:indent => { :width => "2em" },
:event_data => { :color => 'black', :align => :justify },
:event_title => { :color => 'black', :font_weight => :bold },
:high => { :color => "red", :align => :left },
:medium => { :color => 'yellow', :align => :left },
:low => { :color => 'green', :align => :left }
snorby_logo = "public/images/PDF/snorby_logo.png"
pdf.line_width(1)

### GET DATA

### END

### Start Of Cover

pdf.move_down(100)
pdf.image snorby_logo, :scale=>0.7, :position => :center
pdf.text "#{@event.sig.sig_name}", :size => 15, :style => :bold, :align => :center
pdf.text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

pdf.move_down(30)
pdf.start_new_page

###



### END

### Start Of Data
pdf.header [pdf.margin_box.left, pdf.margin_box.top + 20] do
  pdf.text "- #{Time.now.strftime('%A, %B %d, %Y')} - #{@event.sig.sig_name}. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
  pdf.move_down 2
  pdf.stroke_horizontal_rule
  pdf.move_down 30
end

pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 5] do
  pdf.move_down 7
  pdf.stroke_horizontal_rule
  pdf.move_down 3
  pdf.text "- #{pdf.page_count} -", :size => 7, :align => :center
  pdf.move_down 1
  pdf.text "Copyright (c) Snorby.org", :size => 7, :align => :center, :style => :italic, :color => 'black'
end

if @event.blank?
  pdf.move_down(30)
  pdf.text "NO DATA", :size => 30, :style => :bold, :align => :center
end

pdf.move_down(30)
pdf.text "#{@event.sig.sig_name}", :size => 25, :style => :bold, :align => :left
pdf.move_down(10)
pdf.text "Sensor Information:", :size => 15, :style => :bold, :align => :left
a_header = ["Sensor", "Interface", "Hostname", "Event ID", "Event Percentage"]
pdf.table [[@event.sensor.id, @event.sensor.interface, @event.sensor.hostname, @event.id[1], "#{((total_event_count_for?(@event)/Event.all.size.to_f) * 100).round(2)}%"]],
:headers => a_header,
:position => :center,
:width => 500,
:border_width => 1,
:font_size => 12


pdf.move_down(10)
pdf.text "IP Address Information:", :size => 15, :style => :bold, :align => :left
a_header = ["Sensor", "Interface", "Hostname", "Event ID", "Event Percentage"]
pdf.table [[@event.sensor.id, @event.sensor.interface, @event.sensor.hostname, @event.id[1], "#{((total_event_count_for?(@event)/Event.all.size.to_f) * 100).round(2)}%"]],
:headers => a_header,
:position => :center,
:width => 500,
:border_width => 1,
:font_size => 12

### End Of Data
