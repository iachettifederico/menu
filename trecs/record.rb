class Record
  def self.menu(*args)
    return example if args.empty?
    sections = {}
    r = Tree.siblings.each do |item|
      title = item[/\A\s*>\s*(\w+)/, 1]
      if title
        sections[title] = {}
      else
        section = sections.keys.last
        k, v = item.gsub(/\/\Z/, "").split(": ")

        sections[section][k] = v #  = item
      end
    end
    sections
  end

  private
  def self.example
    <<EOF
> First TRecs
- file: /tmp/pepe.trecs
- step: 50/
> Second TRecs
- file: /tmp/toto.trecs
- step: 5000/
EOF
  end
end
