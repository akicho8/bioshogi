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
  config_accessor(:defense_form_check) { true }
end

require_relative "bushido/logger"
require_relative "bushido/vector"
require_relative "bushido/errors"
require_relative "bushido/application_memory_record"
require_relative "bushido/position"
require_relative "bushido/point"
require_relative "bushido/location"
require_relative "bushido/turn_info"
require_relative "bushido/piece"
require_relative "bushido/hand_log"

require_relative "bushido/mini_soldier"
require_relative "bushido/board_parser"
require_relative "bushido/kakiki_format"
require_relative "bushido/csa_board_format"
require_relative "bushido/board"
require_relative "bushido/utils"

require_relative "bushido/xtra_pattern"
require_relative "bushido/soldier"
require_relative "bushido/skill_monitor"
require_relative "bushido/player"
require_relative "bushido/runner"
require_relative "bushido/movabler"
require_relative "bushido/kifu_dsl"
require_relative "bushido/mediator"

require_relative "bushido/shape_info"
require_relative "bushido/teaiwari_info"
require_relative "bushido/sect_info"
require_relative "bushido/defense_group_info"
require_relative "bushido/defense_info"
require_relative "bushido/attack_info"

require_relative "bushido/brain"
require_relative "bushido/evaluator"

require_relative "bushido/parser"
require_relative "bushido/parser/base"
require_relative "bushido/parser/csa_parser"
require_relative "bushido/parser/kif_parser"
require_relative "bushido/parser/ki2_parser"
