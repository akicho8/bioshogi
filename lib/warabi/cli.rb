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
    option :depth_max,  type: :numeric, aliases: "-d",   default: 4
    option :times,      type: :numeric, aliases: "-t",   default: 512
    option :time_limit, type: :numeric, aliases: "--tl", default: 1.0
    option :logging,    type: :boolean, aliases: "-l",   default: false
    option :log_file,   type: :string,                   default: "brain.log"
    def versus
      pp options
      tp options

      if options[:logging]
        log_file = Pathname(options[:log_file])
        FileUtils.rm_rf(log_file)
        Warabi.logger = ActiveSupport::Logger.new(log_file)
      end

      mediator = Mediator.start
      options[:times].times do
        current_player = mediator.current_player

        deepen_score_list_params = {
          time_limit: options[:time_limit],
          depth_max_range: 0..options[:depth_max],
        }
        infos = current_player.brain.deepen_score_list(deepen_score_list_params)
        info = infos.first
        hand = info[:hand]
        mediator.execute(hand.to_sfen, executor_class: PlayerExecutorCpu)

        puts "---------------------------------------- [#{mediator.turn_info.counter}] #{hand}"
        tp deepen_score_list_params
        tp Brain.human_format(infos)
        puts mediator

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
  # Warabi::Cli.start(["piece"])
  Warabi::Cli.start(["versus", "--times", "1"])
end
# >> ---------------------------------------- [1] ▲７六歩(77)
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
# >> |------+--------------+--------+---------------------------+--------|
# >> | 順位 | 候補手       | 評価値 | 読み筋                    | 処理量 |
# >> |------+--------------+--------+---------------------------+--------|
# >> |    1 | ▲７六歩(77) |    205 | △４四歩(43) ▲４四角(88) |    222 |
# >> |    2 | ▲９八香(99) |      0 | △１四歩(13) ▲４六歩(47) |     30 |
# >> |    3 | ▲８六歩(87) |      0 | △１四歩(13) ▲６六歩(67) |     30 |
# >> |    4 | ▲７八銀(79) |      0 | △１四歩(13) ▲１八香(19) |     28 |
# >> |    5 | ▲６八銀(79) |      0 | △１四歩(13) ▲３八飛(28) |     27 |
# >> |    6 | ▲６六歩(67) |      0 | △１四歩(13) ▲９六歩(97) |     30 |
# >> |    7 | ▲７八金(69) |      0 | △１四歩(13) ▲５六歩(57) |     27 |
# >> |    8 | ▲６八金(69) |      0 | △１四歩(13) ▲７六歩(77) |     27 |
# >> |    9 | ▲５八金(69) |      0 | △１四歩(13) ▲２六歩(27) |     25 |
# >> |   10 | ▲５六歩(57) |      0 | △１四歩(13) ▲４六歩(47) |     30 |
# >> |   11 | ▲６八玉(59) |      0 | △１四歩(13) ▲７八銀(79) |     28 |
# >> |   12 | ▲５八玉(59) |      0 | △１四歩(13) ▲１八香(19) |     27 |
# >> |   13 | ▲４八玉(59) |      0 | △１四歩(13) ▲３八飛(28) |     26 |
# >> |   14 | ▲４六歩(47) |      0 | △１四歩(13) ▲５八金(49) |     30 |
# >> |   15 | ▲５八金(49) |      0 | △１四歩(13) ▲７八銀(79) |     25 |
# >> |   16 | ▲４八金(49) |      0 | △１四歩(13) ▲９八香(99) |     25 |
# >> |   17 | ▲３八金(49) |      0 | △１四歩(13) ▲１六歩(17) |     23 |
# >> |   18 | ▲３六歩(37) |      0 | △１四歩(13) ▲３七桂(29) |     31 |
# >> |   19 | ▲４八銀(39) |      0 | △１四歩(13) ▲４六歩(47) |     24 |
# >> |   20 | ▲３八銀(39) |      0 | △１四歩(13) ▲９八香(99) |     23 |
# >> |   21 | ▲２六歩(27) |      0 | △１四歩(13) ▲８六歩(87) |     31 |
# >> |   22 | ▲３八飛(28) |      0 | △１四歩(13) ▲５八金(49) |     29 |
# >> |   23 | ▲４八飛(28) |      0 | △１四歩(13) ▲９六歩(97) |     28 |
# >> |   24 | ▲５八飛(28) |      0 | △１四歩(13) ▲５六歩(57) |     28 |
# >> |   25 | ▲６八飛(28) |      0 | △１四歩(13) ▲７六歩(77) |     28 |
# >> |   26 | ▲７八飛(28) |      0 | △１四歩(13) ▲５八金(49) |     29 |
# >> |   27 | ▲１八飛(28) |      0 | △１四歩(13) ▲９六歩(97) |     30 |
# >> |   28 | ▲１六歩(17) |      0 | △１四歩(13) ▲１七桂(29) |     32 |
# >> |   29 | ▲９六歩(97) |      0 | △１四歩(13) ▲９八香(99) |     33 |
# >> |   30 | ▲１八香(19) |      0 | △１四歩(13) ▲７六歩(77) |     28 |
# >> |------+--------------+--------+---------------------------+--------|
# >> ７六歩(77)
# >> {"depth_max"=>2, "times"=>1, "log_file"=>"brain.log"}
