require "../example_helper"
info = Parser.parse("position startpos moves 7g7f 8c8d 2g2f 4a3b 6i7h 8d8e 8h7g 3c3d 7i6h 2b7g+")
require "active_support/core_ext/benchmark"
def _; "%7.2f ms" % Benchmark.ms { 1.times { yield } } end
bg_file = "../../lib/bioshogi/assets/images/matrix_1024x768.png"
_ { info.to_animation_zip                                        } # => "2064.32 ms"
_ { info.to_animation_zip(bg_file: bg_file, continuous_render: false) } # => "10494.14 ms"
_ { info.to_animation_zip(bg_file: bg_file)                      } # => "7968.24 ms"
