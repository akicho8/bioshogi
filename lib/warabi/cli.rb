# frozen-string-literal: true

$LOAD_PATH.unshift(File.expand_path("..", __dir__))

require "warabi"
require "thor"

module Warabi
  class Cli < Thor
    class_option :debug, type: :boolean

    desc "piece", "駒一覧"
    def piece
      tp Piece.collect(&:attributes)
    end

    desc "versus", "CPU同士の対戦"
    option :depth_max, type: :numeric, default: 1, :aliases => "-d"
    option :random, type: :boolean
    def versus
      p options
      mediator = Mediator.start
      loop do
        puts "-" * 80
        puts mediator

        think_result = mediator.current_player.brain.nega_max_run(options)
        hand = InputParser.slice_one(think_result[:hand])
        puts "指し手: #{hand}"
        mediator.execute(hand)

        killed_soldier = mediator.opponent_player.executor.killed_soldier
        if killed_soldier && killed_soldier.piece.key == :king
          break
        end
      end
      puts mediator.to_kif_a.join(" ")
      p options
    end
  end
end

if $0 == __FILE__
  Warabi::Cli.start(["piece"])
  # Warabi::Cli.start(["versus", "--random"])
end
# >> |--------+------+-------------+---------------+----------------+-----------+------------+------|
# >> | key    | name | basic_alias | promoted_name | promoted_alias | sfen_char | promotable | code |
# >> |--------+------+-------------+---------------+----------------+-----------+------------+------|
# >> | king   | 玉   | 王          |               |                | K         | false      |    0 |
# >> | rook   | 飛   |             | 龍            | 竜             | R         | true       |    1 |
# >> | bishop | 角   |             | 馬            |                | B         | true       |    2 |
# >> | gold   | 金   |             |               |                | G         | false      |    3 |
# >> | silver | 銀   |             | 全            | 成銀           | S         | true       |    4 |
# >> | knight | 桂   |             | 圭            | 成桂           | N         | true       |    5 |
# >> | lance  | 香   |             | 杏            | 成香           | L         | true       |    6 |
# >> | pawn   | 歩   |             | と            |                | P         | true       |    7 |
# >> |--------+------+-------------+---------------+----------------+-----------+------------+------|
