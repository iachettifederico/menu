class Music
  def self.open_list(*args)
    files = args.last.split("\n")
    files = "\"#{files.join("\" \"")}\""

    `#{command} #{files} &&  #{command} --enqueue=\"/#{files}\" && #{command} --play-pause`
  end

  def self.open(*args)
    if args.any?
      file = args.join("/")
      `#{command} --play-uri=\"/#{file}\"`
    else
      "@prompt/Enter a file to reproduce"
    end
  end

  def self.play
    `#{command} --play-pause`
  end

  def self.next
    `#{command} --next`
  end

  def self.previous
    `#{command} --previous`
  end

  def self.playing
    out = `#{command} --print-playing`
    "@prompt/#{out}"
  end

  def self.up
    `#{command} --volume-up`
    volume
  end

  def self.down
    `#{command} --volume-down`
    volume
  end

  def self.mute
    `#{command} --set-volume=0`
    volume
  end

  def self.volume
    out = `#{command} --print-volume`
    "@prompt/#{out}"
  end

  def self.man
    `xiki man/rhythmbox-client`
  end

  def self.new_playlist(*args)
    return "@prompt/Type a name for your playlist" if args.empty?

    name = args.shift
    return ": songs" if args.empty?


    file_names = args.first.split("\n")
    wrong = file_names.select { |f| !File.exist?(f) }
    if wrong.any?
      wrong = wrong.map {|f| "\n  - #{f}"}.join
      return "- The following files does not exist: #{wrong}"
    end
    "@prompt/Playlist #{name} SAVED"
  end

  def self.test
    `#{command} --play-uri=/home/fedex/Music/animals_chives.ogg`
  end
  private
  def self.command
    "rhythmbox-client"
  end
end
