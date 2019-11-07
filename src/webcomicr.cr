require "http/client"
require "logger"
require "file"
require "json"

require "./funs"

COMICSFILE = File.expand_path("~/.comics")
LOG        = Logger.new(STDOUT)

unless File.exists?(COMICSFILE)
  puts "can't find #{COMICSFILE}."
  exit
end

comics = File.open(COMICSFILE) do |file|
  Hash(String, WebcomicDef).from_json(file.gets_to_end)
end

unless ARGV[0]? && comics[ARGV[0]]?
  puts "unknown or missing comic name."
  exit
end

comic = comics[ARGV[0]]

unless File.directory?(comic.path)
  puts "#{comic.path} is not a directory."
  exit
end

Dir.cd comic.path
unless comic.path.ends_with?("/")
  comic.path += "/"
end

if Dir.empty?(comic.path) && !ARGV[1]?
  puts "empty directory, please provide starting url."
  exit
end

counter = 1
next_url = ""
if Dir.empty?(comic.path)
  next_url = ARGV[1]
else
  # get "last" file, split off file extension, split by whitespace
  last_comic = Dir.glob("[0-9]*").sort.last.split(".")[0..-2].join.split(" ")
  next_url = comic.base_url + last_comic[1]
  counter = last_comic[0].to_i
end

headers = nil
if comic.override_user_agent
  headers = HTTP::Headers{"User-Agent" => comic.override_user_agent.not_nil!}
end

loop do
  LOG.info("Fetching ##{counter.to_s.rjust(5, '0')} — #{next_url}")
  response = HTTP::Client.get(next_url, headers: headers)
  body = response.body
  panel_number = nil
  if body.scan(comic.image).size > 1
    panel_number = 1
  end

  body.scan(comic.image) do |match_data|
    image_url = complete_url(match_data[1], next_url)
    image_file = "#{counter.to_s.rjust(5, '0')}#{panel_number ? "-" + panel_number.to_s : ""} #{next_url.lchop(comic.base_url)}.#{image_url.lchop(comic.base_url).split('.')[-1]}"
    LOG.info("Downloading #{image_url}, Target Filename: #{image_file}")
    image_data = HTTP::Client.get(image_url, headers: headers).body
    File.write(image_file, image_data)
    if panel_number
      panel_number += 1
    end
  end

  counter += 1
  break if body.includes? comic.last_page_indicator
  next_url = complete_url(comic.next_link.match(body).not_nil![1], next_url)

  sleep Time::Span.new(0, 0, 1)
end
LOG.info("Finished!")
