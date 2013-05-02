# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/ki2_format_spec.rb" -*-

module Bushido
  module Ki2Format
    class Parser < BaseFormat::Parser
      def self.resolved?(source)
        source = BaseFormat.normalized_source(source)
        !source.match(/^手数.*指手.*消費時間.*$/) && source.match(/\n\n/)
      end

      # フォーマットは読み上げに近い、人間が入力したような "▲７六歩△３四歩" 形式
      #  このフォーマットは▲△がついているので、うまいこと利用すればシミュレーションに使える。
      #  先手だけ10連続で打つとか。
      #
      #   @result.move_infos.should == [
      #     {location: :black, input: "７六歩"},
      #     {location: :white, input: "３四歩", comments: ["コメント1"]},
      #     {location: :black, input: "６六歩"},
      #     {location: :white, input: "８四歩", comments: ["コメント2"]},
      #   ]
      #
      def parse
        @_head, @_body = @source.split(/\n\n/, 2)
        read_header
        @_body.lines.each do |line|
          comment_read(line)
          if line.match(/^\s*[▲△]/)
            @move_infos += line.scan(/([▲△])([^▲△\s]+)/).collect{|mark, input|
              location = Location[mark]
              {location: location, input: input, mov: "#{location.mark}#{input}"}
            }
          end
        end
      end
    end
  end
end
