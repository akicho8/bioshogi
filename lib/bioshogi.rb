require "bioshogi/version"

require "active_support/logger"
require "active_support/configurable"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/class/attribute_accessors"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/string"

require "active_support/dependencies/autoload"
require "active_support/core_ext/array/grouping" # for in_groups_of
require "active_support/core_ext/numeric"        # for 1.minute

require "time"                  # for Time.parse
require "kconv"                 # for toeuc

require "table_format"
require "memory_record"

module Bioshogi
  include ActiveSupport::Configurable
  config_accessor(:skill_monitor_enable) { true }

  mattr_accessor(:run_counts) { Hash.new(0) }
end

require_relative "bioshogi/logger"
require_relative "bioshogi/vector"
require_relative "bioshogi/errors"
require_relative "bioshogi/application_memory_record"
require_relative "bioshogi/kanji_number"
require_relative "bioshogi/simple_model"
require_relative "bioshogi/dimension"
require_relative "bioshogi/yomiage_number_info"
require_relative "bioshogi/place"
require_relative "bioshogi/location"
require_relative "bioshogi/turn_info"
require_relative "bioshogi/order_info"
require_relative "bioshogi/piece_box"
require_relative "bioshogi/official_formatter"
require_relative "bioshogi/yomiage_formatter"
require_relative "bioshogi/yomiage_kanji_info"
require_relative "bioshogi/hand_log"
require_relative "bioshogi/hand_logs"

require_relative "bioshogi/piece"

require_relative "bioshogi/soldier"
require_relative "bioshogi/soldier_box"
require_relative "bioshogi/board_parser"
require_relative "bioshogi/kakiki_board_formatter"
require_relative "bioshogi/csa_board_formatter"
require_relative "bioshogi/board"

require_relative "bioshogi/xtra_pattern"
require_relative "bioshogi/defense_info"
require_relative "bioshogi/attack_info"
require_relative "bioshogi/technique_info"
require_relative "bioshogi/note_info"
require_relative "bioshogi/technique_matcher_info"
require_relative "bioshogi/skill_set"
require_relative "bioshogi/tactic_info"
require_relative "bioshogi/tactic_urls_info"
require_relative "bioshogi/skill_monitor"
require_relative "bioshogi/player"
require_relative "bioshogi/input_parser"
require_relative "bioshogi/input"
require_relative "bioshogi/input_adapter"

require_relative "bioshogi/player_executor_base"
require_relative "bioshogi/player_executor_brain"
require_relative "bioshogi/player_executor_human"
require_relative "bioshogi/player_executor_cpu"

require_relative "bioshogi/movabler"

require_relative "bioshogi/mediator_base"
require_relative "bioshogi/mediator_memento"
require_relative "bioshogi/mediator_test"
require_relative "bioshogi/mediator_variables"
require_relative "bioshogi/mediator_executor"
require_relative "bioshogi/mediator_serializers"
require_relative "bioshogi/mediator_players"
require_relative "bioshogi/mediator_stack"
require_relative "bioshogi/mediator_simple"
require_relative "bioshogi/mediator"

require_relative "bioshogi/notation_dsl"
require_relative "bioshogi/hybrid_sequencer"
require_relative "bioshogi/sequencer"
require_relative "bioshogi/simulator"

require_relative "bioshogi/shape_info"
require_relative "bioshogi/preset_info"
require_relative "bioshogi/sect_info"
require_relative "bioshogi/defense_group_info"

require_relative "bioshogi/brain"
require_relative "bioshogi/evaluator"

require_relative "bioshogi/image_formatter"
require_relative "bioshogi/parser"

require_relative "bioshogi/sfen"
require_relative "bioshogi/usi"

require_relative "bioshogi/kifu_format_info"
require_relative "bioshogi/chess_clock"
