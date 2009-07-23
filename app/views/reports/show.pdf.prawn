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
snorby_logo = "#{RAILS_ROOT}/public/images/PDF/snorby_logo.png"
pdf.line_width(1)

### GET DATA
@h_c = []
@h = []
@m_c = []
@m = []
@l_c = []
@l = []

@report.count_events.each do |event, count|
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

pdf.move_down(100)
pdf.image snorby_logo, :scale=>0.7, :position => :center
pdf.text "#{@report.rtype.capitalize} Security Report", :size => 25, :style => :bold, :align => :center
pdf.text "This report was generated: #{Time.now.strftime('%A, %B %d, %Y')}", :size => 12, :style => :bold, :align => :center

pdf.move_down(30)
pdf.start_new_page

###

### Summary
pdf.text "#{@report.rtype.capitalize} Report Summary", :size => 20, :style => :bold, :align => :center
pdf.stroke_horizontal_rule
pdf.move_down(25)

pdf.text "Event Severity Summary", :size => 15, :style => :bold, :align => :center
pdf.move_down(5)
xheader = ["Low Severity", "Medium Severity", "High Severity", "Total Event Count"]
pdf.table [[@l_c.size, @m_c.size, @h_c.size, @report.events.size]],
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

unless @report.events.blank?
  look_for_nil_sessions = @_line_data
  if look_for_nil_sessions.flatten!.uniq == [1]
    pdf.move_down(15)
    pdf.text "This bar graph describes events separated by their severity levels.", :align => :center, :size => 9
    pdf.move_down(10)
    pdf.image open(Gchart.bar(:axis_labels => [["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], [1, ((@l.size+@m.size+@h.size)/2), (@l.size+@m.size+@h.size)]], :axis_with_labels => ['x', 'y'], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :bar_colors => '00ff28,ffac00,ff3715', :bar_width_and_spacing => {:spacing => 50, :group_spacing => 20})), :position => :center
    pdf.move_down(25)
  else
    pdf.move_down(15)
    pdf.text "Event Severity vs Sessions", :size => 15, :style => :bold, :align => :center
    pdf.text "This line graph describes events separated by their severity levels. Reoccurring events should be filtered out using the snorby front-end, and abnormal events or unexpected spikes in the number of events should be researched further.", :size => 9
    pdf.move_down(10)
    pdf.image open(Gchart.line(:axis_with_labels => ['x','y','r'], :line_color => @_line_color, :data => @_line_data, :size => '500x230')), :position => :center
    pdf.move_down(5)
  end
end
unless @report.events.blank?
  pdf.move_down(10)
  pdf.text "Event Severity vs Event Count", :size => 15, :style => :bold, :align => :center
  pdf.text "Outlined by this pie chart, it displays a comparison of the severity level in an executive format of events received. Typically, a large number of high-severity events is a cause for concern and warrants an investigation.", :size => 9
  pdf.move_down(10)
  if @l.empty? && @m.empty? && @h.empty?
    pdf.image open(Gchart.pie(:line_color => ["00ff28", "ffac00", "ff3715"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
  else
    pdf.image open(Gchart.venn(:line_color => ["00ff28", "ffac00", "ff3715"], :labels => ["Low (#{@l.size})", "Medium (#{@m.size})", "High (#{@h.size})"], :data => [@l.size, @m.size, @h.size], :size => '440x200')), :position => :center
  end
end
pdf.move_down(30)

pdf.start_new_page
### END

### Start Of Data
pdf.header [pdf.margin_box.left, pdf.margin_box.top + 20] do
  pdf.text "- #{Time.now.strftime('%A, %B %d, %Y')} - #{@report.rtype.capitalize} Snorby Report. -", :size => 7, :align => :center, :style => :italic, :color => 'black'
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

if @report.events.blank?
  pdf.text "NO DATA", :size => 30, :style => :bold, :align => :center, :color => :red
else
  pdf.move_down 10
  pdf.text "Events listed below are categorized by severity levels. Common events have been placed into sessions for easy review.", :size => 8, :align => :center, :style => :italic
end

unless @h_c.blank?
  pdf.move_down(20)
  pdf.text "High Severity", :size => 20, :style => :bold, :align => :left
  h = 0
  @h_t_data = Array.new
  pdf.move_down(10)
  @h_c.each do |event|
    h += 1
    @h_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
  end
  h_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
  pdf.table @h_t_data,
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
  pdf.move_down(20)
  pdf.text "Medium Severity", :size => 20, :style => :bold, :align => :left
  m = 0
  @m_t_data = Array.new
  pdf.move_down(10)
  @m_c.each do |event|
    m += 1
    @m_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
  end
  m_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
  pdf.table @m_t_data,
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
  pdf.move_down(20)
  pdf.text "Low Severity", :size => 20, :style => :bold, :align => :left
  h = 0
  @l_t_data = Array.new
  pdf.move_down(10)
  @l_c.each do |event|
    h += 1
    @l_t_data << ["#{event[1]}", "#{event[5]}", "#{event[2]}", "#{event[3]}", "#{event[0]}"]
  end
  l_header = ["Event Name", "Sensor ID", "Source Address", "Destination Address", "Session Count"]
  pdf.table @l_t_data,
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
### End Of Data
