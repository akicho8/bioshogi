# frozen-string-literal: true
# bioshogi versus

if $0 == __FILE__
  require "../cli"
end

module Bioshogi
  class Cli < Thor
    desc "versus", "CPU同士の対戦"
    option :depth_max,   type: :numeric, aliases: "-d", default: 8
    option :times,       type: :numeric, aliases: "-n", default: 512
    option :time_limit,  type: :numeric, aliases: "-t", default: 5.0
    option :round,       type: :numeric, aliases: "-r", default: 1
    option :logging,     type: :boolean, aliases: "-l", default: false
    option :log_file,    type: :string,                 default: "brain.log"
    option :black_diver, type: :string,                 default: "Diver::NegaAlphaDiver"
    option :white_diver, type: :string,                 default: "Diver::NegaScoutDiver"
    def versus
      if options[:logging]
        log_file = Pathname(options[:log_file])
        FileUtils.rm_rf(log_file)
        Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(log_file))
      end

      divers = [
        Bioshogi.const_get(options[:black_diver]),
        Bioshogi.const_get(options[:white_diver]),
      ]
      tp divers
      pp options
      tp options

      win_counts = Location.inject({}) { |a, e| a.merge(e.key => 0) }

      options[:round].times do |round|
        container = Container::Basic.start
        options[:times].times do
          current_player = container.current_player

          deepen_score_list_params = {
            time_limit: options[:time_limit],
            depth_max_range: 0..options[:depth_max],
          }
          diver_class = divers[container.turn_info.current_location.code]
          records = current_player.brain(diver_class: diver_class, evaluator_class: Evaluator::Level3).iterative_deepening(deepen_score_list_params)
          record = records.first
          hand = record[:hand]
          container.execute(hand.to_sfen, executor_class: PlayerExecutor::WithoutMonitor)

          puts "---------------------------------------- [#{container.turn_info.turn_offset}] #{hand} (#{diver_class})"
          # container.players.each { |e| tp e.pressure_report }

          tp deepen_score_list_params
          tp Brain.human_format(records)
          tp container.players.inject({}) { |a, e| a.merge(e.location => e.pressure_rate) }
          puts container
          puts
          puts "#{hand} #{record[:black_side_score]}"
          puts
          puts container.to_kif_oneline

          captured_soldier = current_player.executor.captured_soldier
          if captured_soldier && captured_soldier.piece.key == :king
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
  Bioshogi::Cli.start(["versus", "-r1", "-n1", "-t3", "-d3"])
end

# >> |--------------------------|
# >> | Bioshogi::Diver::NegaAlphaDiver |
# >> | Bioshogi::Diver::NegaScoutDiver |
# >> |--------------------------|
# >> {"depth_max"=>3,
# >>  "times"=>1,
# >>  "time_limit"=>3,
# >>  "round"=>1,
# >>  "logging"=>false,
# >>  "log_file"=>"brain.log",
# >>  "black_diver"=>"Diver::NegaAlphaDiver",
# >>  "white_diver"=>"Diver::NegaScoutDiver"}
# >> |-------------+----------------|
# >> |   depth_max | 3              |
# >> |       times | 1              |
# >> |  time_limit | 3              |
# >> |       round | 1              |
# >> |     logging | false          |
# >> |    log_file | brain.log      |
# >> | black_diver | Diver::NegaAlphaDiver |
# >> | white_diver | Diver::NegaScoutDiver |
# >> |-------------+----------------|
# >> ---------------------------------------- [1] ▲７六歩(77) (Bioshogi::Diver::NegaAlphaDiver)
# >> |-----------------+------|
# >> |      time_limit | 3    |
# >> | depth_max_range | 0..3 |
# >> |-----------------+------|
# >> |------+--------------+--------------+--------+------------+----------|
# >> | 順位 | 候補手       | 読み筋       | ▲形勢 | 評価局面数 | 処理時間 |
# >> |------+--------------+--------------+--------+------------+----------|
# >> |    1 | ▲７六歩(77) | △３四歩(33) | 103400 |         30 | 0.031809 |
# >> |    2 | ▲２六歩(27) | △３四歩(33) | 103400 |         30 | 0.029595 |
# >> |    3 | ▲１六歩(17) | △３四歩(33) | 103394 |         30 | 0.028082 |
# >> |    4 | ▲９六歩(97) | △３四歩(33) | 103394 |         30 | 0.029372 |
# >> |    5 | ▲３六歩(37) | △３四歩(33) | 103394 |         30 | 0.030666 |
# >> |    6 | ▲４六歩(47) | △３四歩(33) | 103393 |         30 | 0.029278 |
# >> |    7 | ▲６六歩(67) | △３四歩(33) | 103393 |         30 | 0.029187 |
# >> |    8 | ▲４八玉(59) | △３四歩(33) | 103392 |         30 |  0.02889 |
# >> |    9 | ▲４八銀(39) | △３四歩(33) | 103392 |         30 | 0.027835 |
# >> |   10 | ▲６八銀(79) | △３四歩(33) | 103392 |         30 | 0.029386 |
# >> |   11 | ▲７八銀(79) | △３四歩(33) | 103392 |         30 | 0.029047 |
# >> |   12 | ▲３八銀(39) | △３四歩(33) | 103392 |         30 | 0.029677 |
# >> |   13 | ▲６八玉(59) | △３四歩(33) | 103392 |         30 | 0.027244 |
# >> |   14 | ▲５八玉(59) | △３四歩(33) | 103392 |         30 | 0.029223 |
# >> |   15 | ▲７八金(69) | △３四歩(33) | 103391 |         30 | 0.027379 |
# >> |   16 | ▲５八金(49) | △３四歩(33) | 103391 |         30 | 0.029436 |
# >> |   17 | ▲６八金(69) | △３四歩(33) | 103391 |         30 | 0.028743 |
# >> |   18 | ▲５八金(69) | △３四歩(33) | 103391 |         30 | 0.028421 |
# >> |   19 | ▲４八金(49) | △３四歩(33) | 103391 |         30 |  0.02853 |
# >> |   20 | ▲３八金(49) | △３四歩(33) | 103391 |         30 | 0.026771 |
# >> |   21 | ▲３八飛(28) | △３四歩(33) | 103391 |         30 |  0.03523 |
# >> |   22 | ▲４八飛(28) | △３四歩(33) | 103391 |         30 | 0.036152 |
# >> |   23 | ▲５八飛(28) | △３四歩(33) | 103391 |         30 | 0.034372 |
# >> |   24 | ▲６八飛(28) | △３四歩(33) | 103391 |         30 | 0.027788 |
# >> |   25 | ▲７八飛(28) | △３四歩(33) | 103391 |         30 | 0.029031 |
# >> |   26 | ▲５六歩(57) | △３四歩(33) | 103390 |         30 | 0.029354 |
# >> |   27 | ▲８六歩(87) | △３四歩(33) | 103390 |         30 | 0.030806 |
# >> |   28 | ▲９八香(99) | △３四歩(33) | 103390 |         30 | 0.029306 |
# >> |   29 | ▲１八香(19) | △３四歩(33) | 103390 |         30 | 0.027871 |
# >> |   30 | ▲１八飛(28) | △３四歩(33) | 103390 |         30 | 0.040798 |
# >> |------+--------------+--------------+--------+------------+----------|
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
# >> ▲７六歩(77) 103400
# >>
# >> ▲７六歩(77)
