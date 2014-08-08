class Browse
  def self.menu(*args)
    if args.empty?
      return "@prompt/Type url"
    end

    txt = args.join("/").strip.gsub(/\Ahttps?:\/\//, "")
    txt.gsub! "\n", ' '
    url = "http://#{txt}"

    Keys.prefix_u ? Browser.url(url) : $el.browse_url(url)
    nil
  end
end
