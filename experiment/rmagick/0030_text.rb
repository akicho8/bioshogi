require "rmagick"
require "rmagick/version"
Magick::VERSION                 # => "4.2.2"
image = Magick::Image.read("netscape:").first
image = Magick::Image.read("logo:").first
image = Magick::Image.new(800, 600, Magick::HatchFill.new('white', 'lightcyan2', 100))

c = Magick::Draw.new

# c.annotate(image, 0, 0, 0, 0, "annotate") do |e| # w, h, x, y
#   e.fill      = 'black'
#   e.pointsize = 32
#   e.gravity   = Magick::CenterGravity
# end

# c.translate(0, 0)
# c.rotate(0)

c.gravity = Magick::CenterGravity
c.fill('red')
c.text(0, 0, "Hello")
c.draw(image)


image.write("_output1.png")
`open _output1.png`




