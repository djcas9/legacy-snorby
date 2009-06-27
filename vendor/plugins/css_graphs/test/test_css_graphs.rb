require 'rubygems'
require 'test/unit'
require 'fileutils'
require 'active_support/core_ext/string/inflections'
require File.dirname(__FILE__) + "/../lib/css_graphs"

# Manually insert this so the helper runs apart from Rails.
class String
  include ActiveSupport::CoreExtensions::String::Inflections
end

class TestCSSGraphs < Test::Unit::TestCase

  include CssGraphs

  def test_bar_graph
    output = ""
    data_for_graph = [['January',10],['February',25],['March',45]]

    output += bar_graph(data_for_graph)
    output += bar_graph(data_for_graph)
    output += bar_graph(data_for_graph)

    write(output)
  end

  def test_multi_bar_graph
    output = ""
    data_for_graph = [['January',10],['February',25],['March',45]], [['January',34],['February',29],['March',80]]

    output += multi_bar_graph_for_size(data_for_graph, 640, 480)
    output += multi_bar_graph_for_size(data_for_graph, 300, 100)
    output += multi_bar_graph_for_size(data_for_graph, 200, 600)

    write(output)
  end

  def test_horizontal_bar_graph
    output = horizontal_bar_graph [["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]]
    write(output)
  end

  def test_complex_bar_graph
    output = complex_bar_graph [["Stout", 10], ["IPA", 80], ["Pale Ale", 50], ["Milkshake", 30]]
    write(output)
  end

  private
  
  def write(data)
    # Clean up calling method name and use as filename.
    filename = caller.first.gsub(/\S+\s`/, '').gsub(/'/, '')
    FileUtils.mkdir_p "test/output"
    File.open(File.dirname(__FILE__) + "/output/#{filename}.html", "w") do |f|
      f.write data
    end
  end
  
  def multi_bar_graph_for_size(data, width=640, height=480)
    multi_bar_graph(data, { :width => width, :height => height }) do |index, variable|
      "/report/#{index}"
    end
  end
    
end
