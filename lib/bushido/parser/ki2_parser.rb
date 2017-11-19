# -*- coding: utf-8; compile-command: "bundle exec rspec ../../spec/ki2_format_spec.rb" -*-

module Bushido
  module Parser
    class Ki2Parser < Base
      class << self
        # 適当に入力したもので解釈できるように厳密にはしない
        def accept?(source)
          # source = Parser.source_normalize(source)
          # source.blank? || source.match?(/^\s*[#{Location.triangles}]/)
          !KifParser.accept?(source) && !CsaParser.accept?(source)
        end
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
        header_read
        header_normalize
        board_read

        normalized_source.lines.each do |line|
          comment_read(line)
          if line.match?(/^\p{blank}*[#{Location.triangles}]?\p{blank}*#{Runner.input_regexp}/)
            line.scan(Runner.input_regexp).each do |parts|
              input = parts.join
              location = Location[@move_infos.count]
              @move_infos << {location: location, input: input, mov: "#{location.mark}#{input}"}
            end
          end
        end
      end
    end
  end
end
