# -*- coding: utf-8 -*-

require "active_support/core_ext/string"
require "active_support/configurable"
require "active_support/core_ext/class/attribute_accessors"
# require "pry-debugger" # これを有効にすると pry + rcodetools の環境でバックトレースがでまくる

require "rain_table"

module Bushido
  include ActiveSupport::Configurable
  config_accessor :defense_form_check
  config.defense_form_check = true

  WHITE_SPACE = /[ #{[0x3000].pack('U')}]/
  SEPARATOR = " "

  def self.parse_file(file, options = {})
    parse(Pathname(file).expand_path.read, options)
  end

  def self.parse(str, options = {})
    options = {
    }.merge(options)
    parser = [KifFormat::Parser, Ki2Format::Parser].find{|parser|parser.resolved?(str)}
    parser or raise FileFormatError, "フォーマットがおかしい : #{str}"
    parser.parse(str, options)
  end
end

require_relative "bushido/version"
require_relative "bushido/vector"
require_relative "bushido/errors"
require_relative "bushido/position"
require_relative "bushido/point"
require_relative "bushido/location"
require_relative "bushido/piece"
require_relative "bushido/hand_log"
require_relative "bushido/mini_soldier"
require_relative "bushido/board"
require_relative "bushido/utils"
require_relative "bushido/static_board"
require_relative "bushido/stock"
require_relative "bushido/xtra_pattern"
require_relative "bushido/soldier"
require_relative "bushido/player"
require_relative "bushido/runner"
require_relative "bushido/movabler"
require_relative "bushido/kifu_dsl"
require_relative "bushido/mediator"

require_relative "bushido/brain"
require_relative "bushido/evaluate"

require_relative "bushido/base_format"
require_relative "bushido/kif_format"
require_relative "bushido/ki2_format"

module Bushido
  Board.send(:include, BaseFormat::Board)
  Soldier.send(:include, BaseFormat::Soldier)
end

module Bushido
  if $0 == __FILE__
    mediator = Mediator.start
    mediator.piece_plot
    mediator.execute("７六歩")
    mediator.execute("３四歩")
    puts mediator
  end
end
