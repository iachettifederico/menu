class Reboot
  def self.menu(*args)
    `export SUDO_ASKPASS=/usr/lib/openssh/gnome-ssh-askpass; sudo reboot`
  end
end
