class Shutdown
  def self.menu(*args)
    `export SUDO_ASKPASS=/usr/lib/openssh/gnome-ssh-askpass; sudo shutdown -h now`
  end
end
