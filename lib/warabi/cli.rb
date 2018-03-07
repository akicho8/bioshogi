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
    option :depth_max,   type: :numeric, aliases: "-d", default: 8
    option :times,       type: :numeric, aliases: "-n", default: 512
    option :time_limit,  type: :numeric, aliases: "-t", default: 5.0
    option :round,       type: :numeric, aliases: "-r", default: 1
    option :logging,     type: :boolean, aliases: "-l", default: false
    option :log_file,    type: :string,                 default: "brain.log"
    option :black_diver, type: :string,                 default: "NegaAlphaDiver"
    option :white_diver, type: :string,                 default: "NegaScoutDiver"
    def versus
      if options[:logging]
        log_file = Pathname(options[:log_file])
        FileUtils.rm_rf(log_file)
        Warabi.logger = ActiveSupport::Logger.new(log_file)
      end

      divers = [
        Warabi.const_get(options[:black_diver]),
        Warabi.const_get(options[:white_diver]),
      ]
      tp divers
      pp options
      tp options

      win_counts = Location.inject({}) { |a, e| a.merge(e.key => 0) }

      options[:round].times do |round|
        mediator = Mediator.start
        options[:times].times do
          current_player = mediator.current_player

          deepen_score_list_params = {
            time_limit: options[:time_limit],
            depth_max_range: 0..options[:depth_max],
          }
          diver_class = divers[mediator.turn_info.current_location.code]
          records = current_player.brain(diver_class: diver_class).interactive_deepning(deepen_score_list_params)
          record = records.first
          hand = record[:hand]
          mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)

          puts "---------------------------------------- [#{mediator.turn_info.counter}] #{hand} (#{diver_class})"
          tp deepen_score_list_params
          tp Brain.human_format(records)
          puts mediator
          puts
          puts "#{hand} #{record[:score2]}"
          puts
          puts mediator.to_kif_oneline

          killed_soldier = current_player.executor.killed_soldier
          if killed_soldier && killed_soldier.piece.key == :king
            win_counts[current_player.location.key] += 1
            Pathname("win_counts.txt").write(win_counts.inspect)
            break
          end
        end
      end
    end
  end
end

if $0 == __FILE__
  # Warabi::Cli.start(["piece"])
  Warabi::Cli.start(["versus", "-r1", "-n1", "-t3", "-d3"])
end
# >> |------------------------|
# >> | Warabi::NegaAlphaDiver |
# >> | Warabi::NegaScoutDiver |
# >> |------------------------|
# >> {"depth_max"=>3,
# >>  "times"=>1,
# >>  "time_limit"=>3,
# >>  "round"=>1,
# >>  "logging"=>false,
# >>  "log_file"=>"brain.log",
# >>  "black_diver"=>"NegaAlphaDiver",
# >>  "white_diver"=>"NegaScoutDiver"}
# >> |-------------+----------------|
# >> |   depth_max | 3              |
# >> |       times | 1              |
# >> |  time_limit | 3              |
# >> |       round | 1              |
# >> |     logging | false          |
# >> |    log_file | brain.log      |
# >> | black_diver | NegaAlphaDiver |
# >> | white_diver | NegaScoutDiver |
# >> |-------------+----------------|
# >> ---------------------------------------- [1] ▲７六歩(77) (Warabi::NegaAlphaDiver)
# >> |-----------------+------|
# >> |      time_limit | 3    |
# >> | depth_max_range | 0..3 |
# >> |-----------------+------|
# >> |------+--------------+---------------------------+------+------------+----------|
# >> | 順位 | 候補手       | 読み筋                    | 形勢 | 評価局面数 | 処理時間 |
# >> |------+--------------+---------------------------+------+------------+----------|
# >> |    1 | ▲７六歩(77) | △４四歩(43) ▲４四角(88) |  205 |       1050 | 0.129571 |
# >> |    2 | ▲９八香(99) | △１四歩(13) ▲４六歩(47) |    0 |         59 | 0.014618 |
# >> |    3 | ▲８六歩(87) | △１四歩(13) ▲６六歩(67) |    0 |         59 | 0.015365 |
# >> |    4 | ▲７八銀(79) | △１四歩(13) ▲１八香(19) |    0 |         57 |   0.0145 |
# >> |    5 | ▲６八銀(79) | △１四歩(13) ▲３八飛(28) |    0 |         56 | 0.012922 |
# >> |    6 | ▲６六歩(67) | △１四歩(13) ▲９六歩(97) |    0 |         59 | 0.015214 |
# >> |    7 | ▲７八金(69) | △１四歩(13) ▲５六歩(57) |    0 |         56 | 0.014731 |
# >> |    8 | ▲６八金(69) | △１四歩(13) ▲７六歩(77) |    0 |         56 | 0.014576 |
# >> |    9 | ▲５八金(69) | △１四歩(13) ▲２六歩(27) |    0 |         54 | 0.015056 |
# >> |   10 | ▲５六歩(57) | △１四歩(13) ▲４六歩(47) |    0 |         59 | 0.014406 |
# >> |   11 | ▲６八玉(59) | △１四歩(13) ▲７八銀(79) |    0 |         57 | 0.015313 |
# >> |   12 | ▲５八玉(59) | △１四歩(13) ▲１八香(19) |    0 |         56 | 0.014563 |
# >> |   13 | ▲４八玉(59) | △１四歩(13) ▲３八飛(28) |    0 |         55 | 0.015561 |
# >> |   14 | ▲４六歩(47) | △１四歩(13) ▲５八金(49) |    0 |         59 | 0.014996 |
# >> |   15 | ▲５八金(49) | △１四歩(13) ▲７八銀(79) |    0 |         54 | 0.015237 |
# >> |   16 | ▲４八金(49) | △１四歩(13) ▲９八香(99) |    0 |         54 | 0.014886 |
# >> |   17 | ▲３八金(49) | △１四歩(13) ▲１六歩(17) |    0 |         52 | 0.013963 |
# >> |   18 | ▲３六歩(37) | △１四歩(13) ▲３七桂(29) |    0 |         60 | 0.014453 |
# >> |   19 | ▲４八銀(39) | △１四歩(13) ▲４六歩(47) |    0 |         53 | 0.013778 |
# >> |   20 | ▲３八銀(39) | △１四歩(13) ▲９八香(99) |    0 |         52 |  0.01624 |
# >> |   21 | ▲２六歩(27) | △１四歩(13) ▲８六歩(87) |    0 |         60 | 0.015151 |
# >> |   22 | ▲３八飛(28) | △１四歩(13) ▲５八金(49) |    0 |         58 | 0.015105 |
# >> |   23 | ▲４八飛(28) | △１四歩(13) ▲９六歩(97) |    0 |         57 | 0.015086 |
# >> |   24 | ▲５八飛(28) | △１四歩(13) ▲５六歩(57) |    0 |         57 | 0.015008 |
# >> |   25 | ▲６八飛(28) | △１四歩(13) ▲７六歩(77) |    0 |         57 | 0.014952 |
# >> |   26 | ▲７八飛(28) | △１四歩(13) ▲５八金(49) |    0 |         58 | 0.014058 |
# >> |   27 | ▲１八飛(28) | △１四歩(13) ▲９六歩(97) |    0 |         59 | 0.016418 |
# >> |   28 | ▲１六歩(17) | △１四歩(13) ▲１七桂(29) |    0 |         61 | 0.014441 |
# >> |   29 | ▲９六歩(97) | △１四歩(13) ▲９七角(88) |    0 |         62 | 0.012523 |
# >> |   30 | ▲１八香(19) | △１四歩(13) ▲７六歩(77) |    0 |         57 | 0.015551 |
# >> |------+--------------+---------------------------+------+------------+----------|
# >> 後手の持駒：なし
# >>   ９ ８ ７ ６ ５ ４ ３ ２ １
# >> +---------------------------+
# >> |v香v桂v銀v金v玉v金v銀v桂v香|一
# >> | ・v飛 ・ ・ ・ ・ ・v角 ・|二
# >> |v歩v歩v歩v歩v歩v歩v歩v歩v歩|三
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# >> | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# >> | ・ ・ 歩 ・ ・ ・ ・ ・ ・|六
# >> | 歩 歩 ・ 歩 歩 歩 歩 歩 歩|七
# >> | ・ 角 ・ ・ ・ ・ ・ 飛 ・|八
# >> | 香 桂 銀 金 玉 金 銀 桂 香|九
# >> +---------------------------+
# >> 先手の持駒：なし
# >> 手数＝1 ▲７六歩(77) まで
# >> 
# >> 後手番
# >> 
# >> ▲７六歩(77) 205
# >> 
# >> ▲７六歩(77)
