# sudo$ apt-get --install -y remove xcowsay
# sudo$ apt-get --purge -y remove xcowsay
class XikiScreen
  attr_reader :line_number
  attr_reader :indent

  def initialize(line_number, indent)
    @line_number = line_number
    @indent = indent
  end
  def clear
    ::Xiki::Move.to_line(line_number)
    ::Xiki::Move.to_end
    ::Xiki::Launcher.hide
  end

  def puts(str)
    ::Xiki::Move.to_end
    ::Xiki::View.<< "\n"
    str.each_line do |line|
      ::Xiki::View.insert("#{indent}  #{line}")
    end
    nil
  end
end

class Apt
  def self.menu_before(*args)
    line_number = ::Xiki::Line.number
    indent      = ::Xiki::Line.indent
    @screen     = XikiScreen.new(line_number, indent)
    nil
  end

  def self.search(*args)
    return "@prompt/Type query" if args.empty?
    if args.count == 1
      query = args.join("/")
      IO.popen("aptitude search #{query}") do |out|
        out.each_line do |line|
          line = line.gsub(/\s*$/, "")
          puts "| #{line}"
        end
      end
      nil
    else
      state, package, desc = args.last.split(/\s\s+/)
      if /\A\| i\w+ .+\Z/ === state
        IO.popen("#{sudo} aptitude remove --purge -y #{package}") do |out|
          out.each_line do |line|
            line.chomp!
            puts "| #{line}"
          end
        end
        nil
      elsif /\A\| p\w+ .+\Z/ === state
        IO.popen("#{sudo} aptitude install -y #{package}") do |out|
          out.each_line do |line|
            line.chomp!
            puts "| #{line}"
          end
        end
        nil
      elsif /\A\| v\w+ .+\Z/ === state
        return "| Virtual package: #{package}"
      end
    end
  end

  def self.full_upgrade(*)
    IO.popen("#{sudo} aptitude update && #{sudo} aptitude -y full-upgrade && notify-send 'System up to date' &")
    "@prompt/Sent to background"
  end

  def self.update(*)
    IO.popen("#{sudo} aptitude update && notify-send 'Package list up to date' &")
    "@prompt/Sent to background"
  end

  private

  def self.puts(str)
    @screen.puts(str)
  end

  def self.puts_l(str)
    @screen.puts(str.chomp)
  end

  def self.sudo
    "export SUDO_ASKPASS=/usr/lib/openssh/gnome-ssh-askpass; sudo "
  end


end
