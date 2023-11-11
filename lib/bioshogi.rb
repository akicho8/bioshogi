# ActiveSupport の core_ext を除いたファイルを関連を個別に読み込むことを ActiveSupport は想定していない
# (個別読み込んでいるアップデートする度に不整合おきる)
# 単に require "active_support" で必須のものをすべて読み込んだ上で必要な core_ext だけ読み込むの正しい
require "active_support"                                     # core_ext/* を除くすべてを読み込む
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/class/attribute_accessors"  # for cattr_accessor
require "active_support/core_ext/module/attribute_accessors" # for mattr_accessor
require "active_support/core_ext/string"
require "active_support/core_ext/array/grouping"             # for in_groups_of
require "active_support/core_ext/numeric"                    # for 1.minute
require "active_support/core_ext/hash"                       # for too_options
require "active_support/core_ext/pathname"                   # for existence

require "pathname"
require "time"     # for Time.parse
require "kconv"    # for toeuc

require "table_format"
require "memory_record"
require "tree_support"

module Bioshogi
  ROOT_DIR   = Pathname(__dir__)
  ASSETS_DIR = ROOT_DIR.join("bioshogi/assets")
  LOG_DIR    = ROOT_DIR.join("bioshogi/log")

  include ActiveSupport::Configurable
  config_accessor(:skill_monitor_enable) { true }
  mattr_accessor(:run_counts) { Hash.new(0) }

  SFEN1 = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/bioshogi/logger.rb")
loader.ignore("#{__dir__}/bioshogi/vector_constants.rb")
loader.ignore("#{__dir__}/bioshogi/errors.rb")
loader.ignore("#{__dir__}/bioshogi/contrib/**/*.rb")
loader.ignore("#{__dir__}/bioshogi/assets")
loader.ignore("#{__dir__}/bioshogi/cli.rb")
loader.ignore("#{__dir__}/bioshogi/cli")
loader.ignore("#{__dir__}/bioshogi/explain/{備考,囲い,戦型,手筋}")
loader.inflector.inflect("cli" => "CLI")

# 開発環境専用のものは遅延読み込みする
loader.do_not_eager_load("#{__dir__}/bioshogi/explain/*_generator.rb")
loader.do_not_eager_load("#{__dir__}/bioshogi/explain/tactic_validator.rb")
loader.do_not_eager_load("#{__dir__}/bioshogi/explain/file_normalizer.rb")
loader.do_not_eager_load("#{__dir__}/bioshogi/extreme_validator.rb")
loader.do_not_eager_load("#{__dir__}/bioshogi/formatter/animation/demo_builder.rb")

# CLI用
loader.do_not_eager_load("#{__dir__}/bioshogi/commands/*.rb")

loader.log! if false
loader.setup

require "bioshogi/logger"
require "bioshogi/vector_constants"
require "bioshogi/errors"

# 必須
# loader.eager_load_namespace(Bioshogi::ScreenImage)

# なくてもよい
loader.eager_load
