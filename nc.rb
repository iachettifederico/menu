class Nc
  def self.menu(*args)
    h = {
      uno: [
        "a",
        "s",
        "d",
        "f",
      ],
      dos: [
        "a",
        "s",
        "d",
        "f",
      ]
    }
    if args.empty?
      menuify(h)
    else
      args
    end
  end

  private

  def self.menuify(hash, opts={})
    key_format   = opts.fetch(:key_format)   { "- <key>:" }
    value_format = opts.fetch(:value_format) { "  - <value>" }
    out = ""
    hash.keys.each do |key|
      out << key_format.gsub(/<key>/, key.to_s)
      out << "\n"

      Array(hash[key]).each do |value|
        #out << "  "
        out << value_format.gsub(/<value>/, value.to_s)
        out << "\n"
      end

    end

    out
  end
end
