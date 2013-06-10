require './gtd_lib.rb'
GDRIVE = '../../../../Google Drive/personal/'
class GtdRunner
  def initialize
    @current_path = File.join(GDRIVE, 'next_actions.mm')
    @mm = MindMap.new(File.join(GDRIVE,'next_actions.mm'))
  end

  def load_map(name)
    unless @mm.name.split(/\s/).join('_') == name
      old_path = @current_path
      begin
        @current_path = File.join(GDRIVE, name)
        @mm = MindMap.new(@current_path) 
      rescue
        @current_path = old_path
        puts "Failed to load '#{name}'"
      end
    end
  end

  def run

    loop do
      print 'gtd> '
      input = gets
      if input.nil?
        print "\n"
        break
      end

      command, *params = input.chomp.split(/\,\s*/)
      case command
        when /\Ahelp\z/i
          puts "Sorry, I can't do that Nathan"
        when /\Aopen\z/i
          puts "You want me to open '#{params}'?"
        when /\Anext\z/i
          self.load_map('next_actions.mm')
          unless params.empty?
            node = @mm.get_node(params.join('/'))
            node.each {|n| puts MindMap.pretty_str(n,-1) }
            if node.empty?
              puts '<no results>'
            end
          else
            @mm.view
          end
        when /\Adump:/i
          self.load_map('next_actions.mm')
          node = @mm.get_node('dump')[0]
          pre_params = command.split(/:/)[1].strip
          params = [pre_params] + params
          params.each do |p|
            new_node = @mm.create_node(p)
            @mm.add_child(node, new_node)
          end
        when /\Asave\z/i
          @mm.save(@current_path)          
        else
          puts 'Invalid command'
      end
    end
  end
end

gtd_instance = GtdRunner.new
gtd_instance.run