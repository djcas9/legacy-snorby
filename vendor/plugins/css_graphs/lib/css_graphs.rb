module CssGraphs

  VERSION='0.1.0'
    
  # Makes a vertical bar graph.
  #
  #  bar_graph [["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]]
  #
  # NOTE: Updated to take an array instead of forcing you to use *array.
  # NOTE: Normalizes data to fit in the viewable area instead of being fixed to 100.
  
  def bar_graph(data=[])
    width = 378
    height = 150
    colors = %w(#ce494a #efba29 #efe708 #5a7dd6 #73a25a)
    floor_cutoff = 24 # Pixels beneath which values will not be drawn in graph
    data_max = data.inject(0) { |memo, array| array.last > memo ? array.last : memo }

    
    html = <<-"HTML"
    <style>
      #vertgraph {    				
          width: #{width}px; 
          height: #{height}px; 
          position: relative; 
          background-color: #eeeeee;
          border: 4px solid #999999;
          font-family: "Lucida Grande", Verdana, Arial;
      }
    
      #vertgraph dl dd {
        position: absolute;
        width: 28px;
        height: 103px;
        bottom: 34px;
        padding: 0 !important;
        margin: 0 !important;
        background-image: url('/images/css_graphs/colorbar.jpg') no-repeat !important;
        text-align: center;
        font-weight: bold;
        color: white;
        line-height: 1.5em;
      }

      #vertgraph dl dt {
        position: absolute;
        width: 48px;
        height: 25px;
        bottom: 0px;
        padding: 0 !important;
        margin: 0 !important;
        text-align: center;
        color: #444444;
        font-size: 0.8em;
      }
    HTML

    bar_offset = 24
    bar_increment = 75
    bar_image_offset = 28
    
    data.each_with_index do |d, index|
      bar_left = bar_offset + (bar_increment * index)
      label_left = bar_left - 10
      background_offset = bar_image_offset * index
      
      html += <<-HTML
        #vertgraph dl dd.#{d[0].to_s.downcase} { left: #{bar_left}px; background-color: #{colors[index]}; background-position: -#{background_offset}px bottom !important; }
        #vertgraph dl dt.#{d[0].to_s.downcase} { left: #{label_left}px; background-position: -#{background_offset}px bottom !important; }
      HTML
    end
    
    html += <<-"HTML"
      </style>
      <div id="vertgraph">
        <dl>
    HTML
    
    data.each_with_index do |d, index|
      scaled_value = scale_graph_value(d.last, data_max, 100)
      html += <<-"HTML"
        <dt class="#{d.first.to_s.downcase}">#{d[0].to_s.humanize}</dt>
        <dd class="#{d.first.to_s.downcase}" style="height: #{scaled_value}px;" title="#{d.last}">#{scaled_value < floor_cutoff ? '' : d.last}</dt>
      HTML
    end
        
    html += <<-"HTML"
        </dl>
      </div>
    HTML
    
    html
  end
  
  
  # Makes a vertical bar graph with several sets of bars.
  #
  # NOTE: Normalizes data to fit in the viewable area instead of being fixed to 100.
  #
  # Example:
  ## <% @data_for_graph = [[['January',10],['February',25],['March',45]],[['January',34],['February',29],['March',80]]] %>
  ## <%= bar_graph (@data_for_graph,{:width => 640,:height => 480}) do |index,variable|
  ##                 url_for( :action => 'report', :month => index) 
  ##               end
  ## %>
  #
  # alldata should be an array of variables, each one an array itself, of the form:
  ##    [['label1',value1],['label2',value2]]
  #
  # options hash:
  #*   :display_value_on_bar   if set to true, will display the value on top each bar, default behavior is not to show the value
  #*   :colors  is an array of colors in hex format: '#EEC2D2' if you don't set them, default colors will be used
  #*    :color_by can be set to 'dimension' or 'index' 
  #*   :width and :height set the dimensions, wich default to 378x150
  #
  # url_creator_block:
  # 
  ##  the url_creator_block receives two parameters, index and variable, that are used to build the bars links. 
  ##  index is the position for this bar's that in its variable array, while variable is the variable this bar represents

  def multi_bar_graph(alldata=[], options={}, &url_creator)
    graph_id = (rand*10000000000000000000).to_i.to_s #we need a unique id for each graph on the page so we can have distinct styles for each of them
    if !options.nil? && options[:width] && options[:height]
      width,height=options[:width].to_i,options[:height].to_i
    else
      width,height = 378,150
    end
    colors = (%w(#ce494a #efba29 #efe708 #5a7dd6 #73a25a))*10 unless colors=options[:colors]
    floor_cutoff = 24 # Pixels beneath which values will not be drawn in graph
    data_max = (alldata.map { |data| data.max{ |a,b| a.last <=> b.last }.last } ).max
    dimensions=alldata.size
    size =  alldata.map{ |data| data.size }.max
    bar_offset = 24 #originally set to 24
    bar_group_width=(width-bar_offset)/size #originally set to 48px
    bar_increment = bar_group_width #originally set to 75
    bar_width=(bar_group_width-bar_offset)/dimensions #originally set to 28px
    bar_image_offset = bar_offset+4 #originally set to 28
    bar_padding = 2

    #p "dimensions = #{dimensions}"
    #p "bar_group_width =#{bar_group_width}"
    #p "bar_width = #{bar_width}"
    #p "bar_increment = #{bar_increment}"

    html = <<-"HTML"
    <style>
      #vertgraph-#{graph_id} {    				
          width: #{width}px; 
          height: #{height}px; 
          position: relative; 
          background-color: #eeeeee;
          border: 4px solid #999999;
          font-family: "Lucida Grande", Verdana, Arial;
      }
    
      #vertgraph-#{graph_id} dl dd {
        position: absolute;
        width: #{bar_width}px;
        height: #{height-50}px;
        bottom: 34px;
        padding: 0 !important;
        margin: 0 !important;
        background-image: url('/images/css_graphs/colorbar.jpg') no-repeat !important;
        text-align: center;
        font-weight: bold;
        color: white;
        line-height: 1.5em;
      }

      #vertgraph-#{graph_id} dl dt {
        position: absolute;
        width: #{bar_group_width}px;
        height: 25px;
        bottom: 0px;
        padding: 0 !important;
        margin: 0 !important;
        text-align: center;
        color: #444444;
        font-size: 0.8em;
      }
    HTML

    alldata.each_with_index do |data,dimension|
#    p "\n drawing dimension #{dimension}"
      data.each_with_index do |d, index|
#        bar_left = bar_offset + (bar_increment * index) 
        bar_group_left = bar_offset + (bar_increment * index) 
        bar_left = bar_group_left + ((bar_width+bar_padding)*dimension)
        #        bar_left = bar_group_left + ( 2*bar_width* (dimension-1))     
#        p "\n bar_left #{bar_left}"
        label_left = bar_group_left - 10
        background_offset = ( bar_image_offset * index ) 
        if options[:color_by]=='index'
          color=colors[index]
        else
          color=colors[dimension]
        end
        html += <<-HTML
          #vertgraph-#{graph_id} dl dd.a#{index.to_s}#{dimension.to_s} { left: #{bar_left}px; background-color: #{color}; background-position: -#{background_offset}px bottom !important; }
          #vertgraph-#{graph_id} dl dt.a#{index.to_s}#{dimension.to_s} { left: #{label_left}px; background-position: -#{background_offset}px bottom !important; }
        HTML
      end
    end  

      html += <<-"HTML"
        </style>
        <div id="vertgraph-#{graph_id}">
          <dl>
      HTML
    alldata.each_with_index do |data,dimension|    
#      data_max = data.inject(0) { |memo, array| array.last > memo ? array.last : memo }
      data.each_with_index do |d, index|
        scaled_value = scale_graph_value(d.last, data_max, height-50)
       if (options[:display_value_on_bar])
         bar_text=(scaled_value < floor_cutoff ? '' : d.last).to_s  #text on top of the bar
       else
          bar_text=''
       end  

     if dimension==0
        html += <<-"HTML"
          <!-- algo -->
          <dt class="a#{index.to_s}#{dimension.to_s}" >#{d[0].to_s}</dt>
        HTML
     end
      @url = url_creator.call(index,dimension) if !url_creator.nil?
      html += <<-"HTML"
      <a href="#{@url}">
        <!-- Tooltip for bar group -->
        <dd class="a#{index.to_s}#{dimension.to_s}" style="height: #{height-50}px;background: none;" title="#{d.last}"></dd>
        <!-- Color bar -->
        <dd class="a#{index.to_s}#{dimension.to_s}" style="height: #{scaled_value}px;" title="#{d.last}">#{bar_text}</dd>
      </a>
     HTML
      end
    end        
    html += <<-"HTML"
        </dl>
      </div>
    HTML
    
    html
  end
  
  # Make a horizontal graph that only shows percentages.
  #
  # The label will be set as the title of the bar element.
  #
  #  horizontal_bar_graph [["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]]
  # 
  # NOTE: Updated to take an array instead of forcing you to use *array.
  # NOTE: Does not normalize data yet...TODO

  def horizontal_bar_graph(data)
    html = <<-"HTML"
      <style>
      /* Basic Bar Graph */
      .graph { 
        position: relative; /* IE is dumb */
        width: 200px; 
        border: 1px solid #B1D632;
        background: #FFFFFF; 
        padding: 0px; 
        margin-top: .1em;
        /* margin-bottom: .5em; */					
      }
      .graph .bar { 
        display: block;	
        position: relative;
        background: #caf638; 
        text-align: center; 
        color: #333; 
        height: 1em; 
        line-height: 1em;									
      }
      .graph .bar span { position: absolute; left: 1em; } /* This extra markup is necessary because IE does not want to follow the rules for overflow: visible */	 
      </style>
    HTML
    
    data.each do |d|
      html += <<-"HTML"
        <div class="graph">
          <strong class="bar" style="width: #{d[1]}%;" title="#{d[0].to_s.humanize}"><span>#{d[1]}%</span> </strong>
        </div>
      HTML
    end
    return html
  end
  
  # Makes a multi-colored bar graph with a bar down the middle, representing the value.
  #
  #  complex_bar_graph [["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]]
  #  
  # NOTE: Updated to take an array instead of forcing you to use *array.
  # NOTE: Does not normalize data yet...TODO

  def complex_bar_graph(data)
    html = <<-"HTML"
      <style>
      /* Complex Bar Graph */
      div#complex_bar_graph dl { 
      	margin: 0; 
      	padding: 0;   
      	font-family: "Lucida Grande", Verdana, Arial;	
      }
      div#complex_bar_graph dt { 
      	position: relative; /* IE is dumb */
      	clear: both;
      	display: block; 
      	float: left; 
      	width: 104px; 
      	height: 20px; 
      	line-height: 20px;
      	margin-right: 17px;              
      	font-size: .75em; 
      	text-align: right; 
      }
      div#complex_bar_graph dd { 
      	position: relative; /* IE is dumb */
      	display: block;   
      	float: left;	 
      	width: 197px; 
      	height: 20px; 
      	margin: 0 0 15px; 
      	background: url("/images/css_graphs/g_colorbar.jpg"); 
      }
      * html div#complex_bar_graph dd { float: none; } /* IE is dumb; Quick IE hack, apply favorite filter methods for wider browser compatibility */
  
      div#complex_bar_graph dd div { 
      	position: relative; 
      	background: url("/images/css_graphs/g_colorbar2.jpg"); 
      	height: 20px; 
      	width: 75%; 
      	text-align:right; 
      }
      div#complex_bar_graph dd div strong { 
      	position: absolute; 
      	right: -5px; 
      	top: -2px; 
      	display: block; 
      	background: url("/images/css_graphs/g_marker.gif"); 
      	height: 24px; 
      	width: 9px; 
      	text-align: left;
      	text-indent: -9999px; 
      	overflow: hidden;
      }
      </style>
      <div id="complex_bar_graph">  
      <dl>
    HTML

    data.each do |d|
      html += <<-"HTML"
        <dt class="#{d[0].to_s.downcase}">#{d[0].to_s.humanize}</dt>
        <dd class="#{d[0].to_s.downcase}" title="#{d[1]}">
        <div style="width: #{d[1]}%;"><strong>#{d[1]}%</strong></div>
      </dd>
    HTML
    end
    
    html += "</dl>\n</div>"
    return html    
  end
  
  ##
  # Scale values within a +max+. The +max+ will usually be the height of the graph.
  
  def scale_graph_value(data_value, data_max, max)
    ((data_value.to_f / data_max.to_f) * max).round
  end
  
end
