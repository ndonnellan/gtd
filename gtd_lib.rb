require 'nokogiri'

class MindMap
  attr_reader :modified, :name

  def self.pretty_str(xml, depth=0, indent=0)
    return "" unless xml.attr('TEXT')
    padding = " " * indent
    str = "#{padding}- #{xml.attr('TEXT')}\n"
    return str if depth == 0

    xml.children.each do |child|
      str << self.pretty_str(child, depth - 1, indent + 2)
    end
    str
  end

  def initialize(filename=nil)
    if filename
      self.load(filename)
    end
    @name = @xml.at_css('node').attr('TEXT')
  end

  def load(filename)
    @xml = Nokogiri::XML(File.open(filename))
    nil
  end

  def to_s
    MindMap.pretty_str(@xml.at_css('node'))
  end

  def view
    puts MindMap.pretty_str(@xml.at_css('node'),-1)
  end

  def modified?
    @modified
  end

  def get_node(path)
    MindMap.get_node_by_name(@xml.at_css('node'), @name + "/" + path)
  end

  def self.get_node_by_name(xml, path)
    # Starts at the top-most node
    node_strs = path.split(/\/(?=[^\/])/)
    
    this_lvl = node_strs.shift
    
    return nil unless xml.attr('TEXT') == this_lvl
    return xml if node_strs.empty?

    res = xml.children.collect do |child|
      MindMap.get_node_by_name(child, node_strs.join('/'))
    end
    res.reject {|x| x.nil?}
  end

  def add_child(parent, child)
    # parent.children[-1].add_next_sibling(Nokogiri::XML::Text.new("\n", @xml))
    parent.children[-1].add_next_sibling(child)
    @modified = true
  end

  def create_node(text)
    new_node = Nokogiri::XML::Node.new "node", @xml
    t = (Time.now.to_f*1000).round
    new_node['CREATED'] = t.to_s
    new_node['ID'] = rand(10**10).to_s
    new_node['MODIFIED'] = t.to_s
    new_node['TEXT'] = text
    new_node
  end

  def save(filename)
    return unless self.modified?

    f = File.open(filename,'w')
    xml = @xml.to_xml
    # Remove the XML declaration at the beginning, as apparently this indicated to 
    # FreeMind that the format is of an older version (or just confuses it)
    xml.slice!(0,xml.match(/\?xml.+\n/).end(0))
    f.puts(xml)
    f.close
  end
end
