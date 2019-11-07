class Regex
  def initialize(parser : JSON::PullParser)
    initialize(parser.read_string)
  end
end

class WebcomicDef
  JSON.mapping(
    path: String,
    base_url: String,
    last_page_indicator: String,
    next_link: Regex,
    image: Regex,
    override_user_agent: {type: String, nilable: true}
  )
end

def complete_url(path, current_url)
  if path.starts_with?("https://") || path.starts_with?("http://")
    # full URL
    path
  elsif path.starts_with?("/")
    # absolute path on the webhost
    current_url.split("/")[0..2].join("/") + path
  elsif current_url.split("/").last.starts_with?("?")
    # relative path but with query parameter instead of path component, chop it off
    current_url.split("/")[0..-2].join("/") + "/" + path
  else
    # relative path
    current_url.split("/")[0..-1].join("/") + "/" + path
  end
end
