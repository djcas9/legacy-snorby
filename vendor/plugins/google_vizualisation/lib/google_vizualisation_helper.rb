module GoogleVizualisationHelper
  def google_vizualisation_tag(viz)
    result = viz.render
    result << "\n"
    result << <<-eos
      <div id="#{viz.uid}" style="width: #{viz.width}px; height: #{viz.height}px;"></div>
    eos
#    RAILS_DEFAULT_LOGGER.debug(result)
    return result
  end
  
  def google_vizualisation_include_tag
    return <<-eos
      <script type="text/javascript" src="http://www.google.com/jsapi"></script>\n
    eos
  end
end