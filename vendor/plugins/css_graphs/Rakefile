require 'rake'
require 'hoe'
require 'lib/css_graphs'

Hoe.new('css_graphs', CssGraphs::VERSION) do |p|
  p.rubyforge_name = 'seattlerb'
  p.author = 'Geoffrey Grosenbach'
  p.email = 'boss AT topfunky.com'
  p.summary = 'Generates a configurable, CSS-tagged HTML calendar.'
  p.description = "A simple method to create an HTML calendar for a single month. Can be styled with CSS. Usable with Ruby on Rails."
  p.url = "http://rubyforge.org/projects/seattlerb"
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.clean_globs = ['test/output', 'email.txt']
end
