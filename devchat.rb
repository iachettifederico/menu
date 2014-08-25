require "etc"

class Devchat
  def self.start(*args)
    out = run "rvm 2.1.2 do devchat #{apps(args)} -s", :clean
    out.each_line.map { |line|
      app, url = line.split(":", 2)
      app = app.strip
      url = "\n  - @browse/" + url.strip.chomp + "/"
      "#{app}:#{url}"
    }
  end

  def self.stop(*args)
    run "rvm 2.1.2 do devchat #{apps(args)} -k"
  end

  def self.restart(*args)
    out = run "rvm 2.1.2 do devchat #{apps(args)} -r", :clean
    out.each_line.map { |line|
      app, url = line.split(":", 2)
      app = app.strip
      url = "\n  - @browse/" + url.strip.chomp + "/"
      "#{app}/#{url}"
    }
  end

  def self.bundle(*args)
    run "rvm 2.1.2 do devchat #{apps(args)} -b"
  end

    def self.update_core(*args)
    run "rvm 2.1.2 do devchat api admin --command='bundle update core_devchat_tv'"
  end
  
  def self.update_auth(*args)
    run "rvm 2.1.2 do devchat devchat admin sponsorships --command='bundle update auth_devchat_tv'"
  end

  def self.recreate_database(*args)
    run "rvm 2.1.2 do devchat #{apps(args)} -m"
  end

  def self.urls(*args)
    out = run "rvm 2.1.2 do devchat #{apps(args)} -u", :clean
    out.each_line.map { |line|
      app, url = line.split(":", 2)
      app = app.strip
      url = "\n  - @browse/" + url.strip.chomp + "/"
      "#{app}:#{url}"
    }
  end

  def self.paths(*args)
    out = run "rvm 2.1.2 do devchat #{apps(args)} -p", :clean
    out = out.each_line.map { |line|
      app, path = line.split(":", 2)
      app = app.strip
      path = "\n  - @" + path.strip.chomp + "/"
      "#{app}:#{path}"
    }
    ["@" + "#{path}"] + out
  end

  def self.trello
    $el.browse_url("https://trello.com/b/AlFU3lNp/devchat-tv")
    "@prompt/Opened in browser"
  end

  def self.harvest
    $el.browse_url("https://excellence.harvestapp.com/time")
    "@prompt/Opened in browser"
  end
  private

  def self.apps(args)
    args.flatten!
    wrong_apps = args.select { |app|
      ! all.include?(app)
    }
    raise "Unknown app(s) #{wrong_apps.join(', ')}" if wrong_apps.any?

    res = (args.empty? || args == ["all"]) ? all : args
    res.join(" ")
  end

  def self.run(command, clean=false)
    output = Dir.chdir(path) do
      `#{command}`
    end
    unless clean
      output = output.each_line.map { |line| "| #{line}" }.join
    end
    output
  end

  def self.all
    @all ||= get_all
  end

  def self.get_all
    all = run "rvm 2.1.2 do devchat --apps", :clean
    all.split("\n")
  end

  def self.path
    "/home/fedex/code/DevChat.tv/"
  end
end
