require 'rubygems'
require 'mechanize'
require 'logger'
require 'open-uri'

TAGS          = ""
BOARD         = ""
RES           = "1920x177"
SEARCH_STYLE  = "larger"
SFW           = "2"
LAST_IMAGE    = ""
IMAGE_LINKS   = false 
RANDOM_IMAGE  = ""
COUNT         = 0

while true do
if IMAGE_LINKS == false
  IMAGE_LINKS = []
  mech = Mechanize.new
  
  page = mech.get("http://4walled.cc/search.php?tags=#{TAGS}&board=#{BOARD}&width_aspect=#{RES}&searchstyle=#{SEARCH_STYLE}&sfw=#{SFW}&search=random")

  image_tags = page.search("li.image").css("a") 
  image_pre_links = image_tags.map { |link| link['href'] }

  image_pre_links.each do |link|
    image_page = Nokogiri::HTML(open(link))
    IMAGE_LINKS.push(image_page.at_css("div#mainImage > a")['href'])
  end
end
RANDOM_IMAGE = IMAGE_LINKS[rand(IMAGE_LINKS.length)]
system "rm /tmp/#{LAST_IMAGE}"
LAST_IMAGE = RANDOM_IMAGE.split("/").last

open("/tmp/#{LAST_IMAGE}", 'wb') do |file|
  file << open(RANDOM_IMAGE).read
end

system "awsetbg /tmp/#{LAST_IMAGE}"
sleep 2
COUNT+=1
if(COUNT > 20)
  IMAGE_LINKS = false
  puts "NEW SHIT COMING"
end
end
