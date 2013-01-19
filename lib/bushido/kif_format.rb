# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

module Bushido
  module KifFormat
    class Parser < BaseFormat::Parser
      def self.resolved?(source)
        source = normalized_source(source)
        source.match(/^手数.*指手.*消費時間.*$/) && !source.match(/^変化：/)
      end

      # | # ----  Kifu for Windows V6.26 棋譜ファイル  ----
      # | key：value
      # | 手数----指手---------消費時間--
      # | *コメント0
      # |    1 ７六歩(77)   ( 0:00/00:00:00)
      def parse
        @_head, @_body = @source.split(/^手数.*指手.*消費時間.*$/, 2)
        read_header
        @_body.lines.each do |line|
          comment_read(line)
          if md = line.match(/^\s+(?<index>\d+)\s+(?<input>\S.*?)\s+\(\s*(?<spent_time>.*)\)/)
            @move_infos << {:index => md[:index], :input => md[:input], :spent_time => md[:spent_time]}
          end
        end
      end
    end

    module Soldier
    end

    module Board
    end
  end
end
