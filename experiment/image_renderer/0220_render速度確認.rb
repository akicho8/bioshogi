require "../setup"
require "color"

parser = Parser.parse(SFEN1)
object = parser.image_renderer(bg_file: ASSETS_DIR.join("images/matrix_1024x768.png"))
require "active_support/core_ext/benchmark"
def _; "%7.2f ms" % Benchmark.ms { 20.times { yield } } end
_ { object.render } # => "8551.17 ms"
