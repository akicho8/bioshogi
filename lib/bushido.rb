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

  SEPARATOR = " "
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

require_relative "bushido/parser"
