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
high_i = "public/images/PDF/high.png"
medium_i = "public/images/PDF/medium.png"
low_i = "public/images/PDF/low.png"
pdf.line_width(1)

### GET DATA
@h_c = []
@h = []
@m_c = []
@m = []
@l_c = []
@l = []

@search.count_events.each do |event, count|
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

############
g = Gruff::Mini::Pie.new
g.no_data_message
g.theme = {
  :colors => ["#ff3d46", "#f9e92e", "#2dc322"],
  :marker_color => "black",
  :background_colors => %w(white white)
}
g.data("High", @h_c.size)
g.data("Medium", @m_c.size)
g.data("Low", @l_c.size)

g.write('/tmp/1.jpg')

g = Gruff::Bar.new
g.no_data_message
g.theme = {
  :colors => ["#ff3d46", "#f9e92e", "#2dc322"],
  :marker_color => "black",
  :background_colors => %w(white white)
}

g.data("High", @h_c.size)
g.data("Med", @m_c.size)
g.data("Low", @l_c.size)


# g.data("Medium", @m_c.size)
# g.data("Low", @l_c.size)

g.write('/tmp/2.jpg')


g1 = '/tmp/1.jpg'
g2 = '/tmp/2.jpg'

############

### Start Of Cover

pdf.move_down(100)
pdf.image snorby_logo, :scale=>0.7, :position => :center
pdf.text "Security Report", :size => 25, :style => :bold, :align => :center
pdf.text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

pdf.move_down(30)
pdf.start_new_page

###

### Summary
pdf.move_down(5)
pdf.text "Snorby Report Summary", :size => 20, :style => :bold, :align => :center
pdf.stroke_horizontal_rule
pdf.move_down(50)
if !@h.blank? and !@m.blank? and !@l.blank?
  pdf.image open(Gchart.line(:labels => ["High", "Medium", "Low"], :theme => :thirty7signals, :data => [@h, @m, @l], :size => '500x230')), :position => :center
end
pdf.move_down(20)
header = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
pdf.table [[pluralize(@l_c.size, "Event"), pluralize(@m_c.size, "Event"), pluralize(@h_c.size, "Event"), pluralize(@search.events.size, "Event")]],
:headers => header,
:position => :center,
:width => 500,
:border_width => 1,
:font_size => 12
pdf.move_down(10)
pdf.image open(Gchart.pie_3d(:labels => ['Low', 'Medium', 'High'], :data => [@l.size, @m.size, @h.size], :size => '400x200')), :position => :center
pdf.move_down(40)
#pdf.image g1, :scale => 0.2, :position => :center
#pdf.image g2, :scale => 0.5, :position => :center
pdf.start_new_page

### END

### Start Of Data
pdf.header [pdf.margin_box.left, pdf.margin_box.top + 20] do
  pdf.text "- #{Time.now.strftime('%A, %B %d, %Y')} - Snorby Report. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
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

unless @h_c.blank?
  pdf.move_down(20)
  pdf.text "High Severity", :size => 20, :style => :bold, :align => :left
  h = 0
  pdf.move_down(10)
  @h_c.each do |event|
    h += 1
    pdf.text "#{h}. <b>#{event[1]}</b> (#{pluralize(event[0], "Session")})"
    pdf.text "    * Source: #{event[2]} - Destination: #{event[3]}"
    pdf.move_down(7)
  end
end

unless @m_c.blank?
  pdf.move_down(20)
  pdf.text "Medium Severity", :size => 20, :style => :bold, :align => :left
  m = 0
  pdf.move_down(10)
  @m_c.each do |event|
    m += 1
    pdf.text "#{m}. <b>#{event[1]}</b> (#{pluralize(event[0], "Session")})"
    pdf.text "    * Sensor: #{event[5]}"
    pdf.text "    * Source: #{event[2]} - Destination: #{event[3]}"
    pdf.move_down(7)
  end
end

unless @l_c.blank?
  pdf.move_down(20)
  pdf.text "Low Severity", :size => 20, :style => :bold, :align => :left
  l = 0
  pdf.move_down(10)
  @l_c.each do |event|
    l += 1
    pdf.text "#{l}. <b>#{event[1]}</b> (#{pluralize(event[0], "Session")})"
    pdf.text "    * Source: #{event[2]} - Destination: #{event[3]}"
    pdf.move_down(7)
  end
end
### End Of Data
