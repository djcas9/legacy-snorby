class CssGraphsGenerator < Rails::Generator::Base  

  def manifest
    record do |m|
      css_graphs_dir = File.join("public", "images", "css_graphs")
      m.directory css_graphs_dir

      Dir.open(File.join(File.dirname(__FILE__), "templates")).entries.each do |file|
        next if File.directory?(file)
        m.file file, File.join(css_graphs_dir, file)
      end

    end
  end
end
