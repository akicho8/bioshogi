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
      # :xcontainer_class                 => Container::Fast,
    })
  object = info.screen_image_renderer({width: 100, height: 100})
  object.to_blob_binary[0..3]           # => "\x89PNG", "\x89PNG", "\x89PNG", "\x89PNG", "\x89PNG"
end

require "active_support/core_ext/benchmark"
def _; "%7.2f ms" % Benchmark.ms { 5.times { yield } } end
_ { test1 } # => "   0.01 ms"
_ { test2 } # => "3144.33 ms"
