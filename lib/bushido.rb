require_relative "bushido/version"

require "active_support/logger"
require "active_support/configurable"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/class/attribute_accessors"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/string"

# require "pry-debugger" # これを有効にすると pry + rcodetools の環境でバックトレースがでまくる

require "org_tp"
require "memory_record"

module Bushido
  include ActiveSupport::Configurable
  config_accessor(:defense_form_check) { false }

  WHITE_SPACE = /[ #{[0x3000].pack('U')}]/
  SEPARATOR = " "

  class << self
    def parse_file(file, **options)
      parse(Pathname(file).expand_path.read, options)
    end

    def parse(str, **options)
      options = {
      }.merge(options)

      parser = [KifFormat::Parser, Ki2Format::Parser].find do |e|
        e.resolved?(str)
      end
      unless parser
        raise FileFormatError, "棋譜のフォーマットが不明です : #{str}"
      end
      parser.parse(str, options)
    end
  end
end

require_relative "bushido/logger"
require_relative "bushido/vector"
require_relative "bushido/errors"
require_relative "bushido/position"
require_relative "bushido/point"
require_relative "bushido/location"
require_relative "bushido/piece"
require_relative "bushido/hand_log"
require_relative "bushido/mini_soldier"
require_relative "bushido/kakiki_format"
require_relative "bushido/board"
require_relative "bushido/utils"
require_relative "bushido/static_board_info"
require_relative "bushido/xtra_pattern"
require_relative "bushido/soldier"
require_relative "bushido/player"
require_relative "bushido/runner"
require_relative "bushido/movabler"
require_relative "bushido/kifu_dsl"
require_relative "bushido/mediator"

require_relative "bushido/brain"
require_relative "bushido/evaluator"

require_relative "bushido/base_format"
require_relative "bushido/kif_format"
require_relative "bushido/ki2_format"
