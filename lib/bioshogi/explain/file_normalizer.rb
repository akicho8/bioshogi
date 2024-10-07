module Bioshogi
  module Explain
    class FileNormalizer
      def call
        TacticInfo.all_elements.each.with_index(&method(:normalize_one))
      end

      private

      def normalize_one(elem, index)
        NormalizeOne.new(elem, index).call
      end

      class NormalizeOne
        def initialize(elem, index)
          @elem = elem
          @index = index
        end

        def call
          if @file = @elem.sample_kif_or_ki2_file
            @old_text = @file.read
            @new_text = Parser.parse(source_text).to_kif
            new_file.write(@new_text)
            puts "#{mark} [#{@index.next} / #{TacticInfo.all_elements.size}] #{new_file}"
          else
            puts "#{@elem} に対応するファイルが見つかりません"
          end
        end

        private

        def source_text
          @old_text.gsub(/(先手|後手)の(戦法|囲い|手筋|備考|棋風)：.*\R/, "")
        end

        def new_file
          @file.sub_ext(".kif") # ki2 だった場合を考慮する
        end

        def mark
          if @old_text == @new_text
            " "
          else
            "U"
          end
        end
      end
    end
  end
end
