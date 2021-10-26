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
  mattr_accessor(:if_starting_from_the_2_hand_second_is_also_described_from_2_hand_first_kif) { false } # 2手目から始まる場合はKIFも2手目からとしてKIFに書き出す

  mattr_accessor(:run_counts) { Hash.new(0) }

  SFEN1 = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"
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
require_relative "bioshogi/yomiage_format_methods"
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

require_relative "bioshogi/monitor_mod"
require_relative "bioshogi/hand_logs_mod"
require_relative "bioshogi/player_executor_base"
require_relative "bioshogi/player_executor_brain"
require_relative "bioshogi/player_executor_human"
require_relative "bioshogi/player_executor_without_monitor"

require_relative "bioshogi/movabler"

require_relative "bioshogi/mediator_base"
require_relative "bioshogi/mediator_memento"
require_relative "bioshogi/mediator_test"
require_relative "bioshogi/mediator_variables"
require_relative "bioshogi/mediator_executor"
require_relative "bioshogi/mediator_serializers"
require_relative "bioshogi/mediator_serializer_checkmate_yomiage"
require_relative "bioshogi/mediator_players"
require_relative "bioshogi/mediator_stack"
require_relative "bioshogi/mediator_simple"
require_relative "bioshogi/mediator_fast"
require_relative "bioshogi/mediator"

require_relative "bioshogi/notation_dsl"
require_relative "bioshogi/hybrid_sequencer"
require_relative "bioshogi/sequencer"
require_relative "bioshogi/simulator"

require_relative "bioshogi/shape_info"
require_relative "bioshogi/preset_info"
require_relative "bioshogi/sect_info"
require_relative "bioshogi/defense_group_info"

require_relative "bioshogi/evaluator"
require_relative "bioshogi/diver"
require_relative "bioshogi/brain"

require_relative "bioshogi/csa_header_info"
require_relative "bioshogi/last_action_info"
require_relative "bioshogi/kifu_format_info"
require_relative "bioshogi/chess_clock"

require_relative "bioshogi/formatter/anything"

require_relative "bioshogi/progress_cop"
require_relative "bioshogi/media"
require_relative "bioshogi/builder"
require_relative "bioshogi/kif_builder"
require_relative "bioshogi/ki2_builder"
require_relative "bioshogi/csa_builder"
require_relative "bioshogi/sfen_builder"
require_relative "bioshogi/bod_builder"
require_relative "bioshogi/yomiage_builder"
require_relative "bioshogi/akf_builder"
require_relative "bioshogi/hand_log_akf_formatter"
require_relative "bioshogi/image_renderer"
require_relative "bioshogi/cover_renderer"
require_relative "bioshogi/audio_theme_info"
require_relative "bioshogi/animation_builder_timeout"
require_relative "bioshogi/system_support"
require_relative "bioshogi/ffmpeg_support"
require_relative "bioshogi/serial_filename_generator"
require_relative "bioshogi/animation_mp4_builder"
require_relative "bioshogi/animation_zip_builder"
require_relative "bioshogi/animation_gif_builder"
require_relative "bioshogi/animation_apng_builder"
require_relative "bioshogi/animation_webp_builder"
require_relative "bioshogi/parser"

require_relative "bioshogi/sfen"
require_relative "bioshogi/sfen_facade"
