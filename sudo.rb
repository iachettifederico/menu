class Sudo
  def self.menu(*args)
    return "@prompt/Type Command" if args.empty?

    sudo = "export SUDO_ASKPASS=/usr/lib/openssh/gnome-ssh-askpass; sudo"
    cmd  = args.join("/")

    result = []
    IO.popen("#{sudo} #{cmd}") do |out|
      out.each_line do |line|
        result << "  | #{line}"
      end
    end
    result.join
  end
end
