class Disk
  def self.menu(*args)
    df = `df -h`
    splitted = df.split("\n")
    head = "| #{splitted.first}"
    results = splitted.grep(/\/dev\//)
    disks = results.map {|l| "| #{l}"}.join("\n")
    head + "\n" + disks
  end
end
