require "../setup"

@turn_limit = 100

def test1
  # info = Parser.parse(Pathname("katomomo.kif").read, turn_limit: @turn_limit)
  # object = info.screen_image_renderer({width: 100, height: 100})
  # object.to_png[0..3]           # => 
end

def test2
  info = Parser.parse(Pathname("../katomomo.kif").read, {
      :turn_limit                     => @turn_limit,
      # :skill_monitor_enable           => false,
      # :skill_monitor_technique_enable => false,
      :candidate_enable                 => false,
      :validate_enable                  => false,
      # :xcontainer_class                 => Container::XcontainerFast,
    })
  object = info.screen_image_renderer({width: 100, height: 100})
  object.to_blob[0..3]           # => 
end

require "active_support/core_ext/benchmark"
def _; "%7.2f ms" % Benchmark.ms { 5.times { yield } } end
_ { test1 } # => "   0.01 ms"
_ { test2 } # => 
# ~> -:21:in `test2': undefined method `to_blob' for #<Bioshogi::ScreenImage::Renderer:0x00007fd020e36f78> (NoMethodError)
# ~> 	from -:27:in `block in <main>'
# ~> 	from -:25:in `block (2 levels) in _'
# ~> 	from -:25:in `times'
# ~> 	from -:25:in `block in _'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/2.6.0/benchmark.rb:308:in `realtime'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.1.7/lib/active_support/core_ext/benchmark.rb:14:in `ms'
# ~> 	from -:25:in `_'
# ~> 	from -:27:in `<main>'
