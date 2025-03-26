# 直接 require "~/src/bioshogi/lib/bioshogi" されたときに ~/src/bioshogi/lib をパスに加える
# そうしないとグローバルで入れた gem の方を読んでしまう
unless $LOAD_PATH.include?(__dir__)
  $LOAD_PATH.unshift(__dir__)
end

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
  ROOT       = Pathname(__dir__)
  ASSETS_DIR = ROOT.join("bioshogi/assets")
  LOG_DIR    = ROOT.join("bioshogi/log")
  TMP_DIR    = ROOT.join("../tmp")

  include ActiveSupport::Configurable
  config_accessor(:analysis_feature) { true }
  mattr_accessor(:run_counts) { Hash.new(0) }

  SFEN1 = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"
  SFEN2 = "position sfen 1plnsgbrk/1+p+l+n+sgbrk/1+P+L+N+SGBRK/1PLNSGBRK/9/9/9/9/9 b - 1"

  ANALYSIS_VERSION = 3
end

if true
  require "zeitwerk"
  loader = Zeitwerk::Loader.for_gem

  # 自動で読み込まないファイルやディレクトリを指定する
  loader.ignore("#{__dir__}/bioshogi/logger.rb")
  loader.ignore("#{__dir__}/bioshogi/vector_constants.rb")
  loader.ignore("#{__dir__}/bioshogi/errors.rb")
  loader.ignore("#{__dir__}/bioshogi/contrib/**/*.rb")
  loader.ignore("#{__dir__}/bioshogi/assets")
  loader.ignore("#{__dir__}/bioshogi/analysis/{備考,囲い,戦法,手筋}")

  # 変換ルール調整
  loader.inflector.inflect("cli" => "CLI")
  loader.inflector.inflect("ai" => "AI")

  # 開発環境専用のものは遅延読み込みする
  loader.do_not_eager_load("#{__dir__}/bioshogi/analysis/*_generator.rb")
  loader.do_not_eager_load("#{__dir__}/bioshogi/analysis/tactic_validator.rb")
  loader.do_not_eager_load("#{__dir__}/bioshogi/analysis/file_normalizer.rb")
  loader.do_not_eager_load("#{__dir__}/bioshogi/extreme_validator.rb")
  loader.do_not_eager_load("#{__dir__}/bioshogi/formatter/animation/demo_builder.rb")
  loader.do_not_eager_load("#{__dir__}/bioshogi/cli.rb")

  # CLI用
  # loader.do_not_eager_load("#{__dir__}/bioshogi/commands/*.rb")

  loader.log! if false

  loader.setup

  require "bioshogi/logger"
  require "bioshogi/vector_constants"
  require "bioshogi/errors"

  # 必須
  # loader.eager_load_namespace(Bioshogi::ScreenImage)

  # なくてもよい
  loader.eager_load
end
