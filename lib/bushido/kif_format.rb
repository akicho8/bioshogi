# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/kif_format_spec.rb" -*-

module Bushido
  module KifFormat
    class Parser < BaseFormat::Parser
      def self.resolved?(source)
        source = BaseFormat.normalized_source(source)
        source.match(/^手数.*指手.*消費時間.*$/) && !source.match(/^変化：/)
      end

      # | # ----  Kifu for Windows V6.26 棋譜ファイル  ----
      # | key：value
      # | 手数----指手---------消費時間--
      # | *コメント0
      # |    1 ７六歩(77)   ( 0:00/00:00:00)
      #
      #   @result.move_infos.first.should == {:index => "1", :input => "７六歩(77)", :spent_time => "0:10/00:00:10", :comments => ["コメント1"]}
      #   @result.move_infos.last.should  == {:index => "5", :input => "投了", :spent_time => "0:10/00:00:50"}
      #
      def parse
        @_head, @_body = @source.split(/^手数.*指手.*消費時間.*$/, 2)
        read_header
        @_body.lines.each do |line|
          comment_read(line)
          if md = line.match(/^\s+(?<index>\d+)\s+(?<input>\S.*?)\s+\(\s*(?<spent_time>.*)\)/)
            location = Location["#{md[:index]}手目"]
            @move_infos << {:index => md[:index], :location => location, :input => md[:input], :mov => "#{location.mark}#{md[:input]}", :spent_time => md[:spent_time]}
          end
        end
      end
    end
  end
end
