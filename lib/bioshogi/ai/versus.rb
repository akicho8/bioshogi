# -*- compile-command: "../../../.bin/bioshogi versus" -*-

module Bioshogi
  module AI
    class Versus
      concern :CLI do
        included do
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
            Versus.new(options.to_options).call
          end
        end
      end

      def initialize(options = {})
        @options = {
          :depth_max   => 8,
          :times       => 512,
          :time_limit  => 5.0,
          :round       => 1,
          :logging     => false,
          :log_file    => "brain.log",
          :black_diver => "Diver::NegaAlphaDiver",
          :white_diver => "Diver::NegaScoutDiver",
        }.merge(options)
      end

      def call
        if @options[:logging]
          log_file = Pathname(@options[:log_file])
          FileUtils.rm_rf(log_file)
          Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(log_file))
        end

        divers = [
          Bioshogi::AI.const_get(@options[:black_diver]),
          Bioshogi::AI.const_get(@options[:white_diver]),
        ]
        tp divers
        pp @options
        tp @options

        win_counts = Location.inject({}) { |a, e| a.merge(e.key => 0) }

        @options[:round].times do |round|
          container = Container::Basic.start
          @options[:times].times do
            current_player = container.current_player

            deepen_score_list_params = {
              time_limit: @options[:time_limit],
              depth_max_range: 0..@options[:depth_max],
            }
            diver_class = divers[container.turn_info.current_location.code]
            records = current_player.brain(diver_class: diver_class, evaluator_class: AI::Evaluator::Level3).iterative_deepening(deepen_score_list_params)
            record = records.first
            hand = record[:hand]
            container.execute(hand.to_sfen, executor_class: PlayerExecutor::WithoutMonitor)

            puts "---------------------------------------- [#{container.turn_info.turn_offset}] #{hand} (#{diver_class})"
            # container.players.each { |e| tp e.pressure_report }

            tp deepen_score_list_params
            tp AI::Brain.human_format(records)
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
end
