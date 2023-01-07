module Bioshogi
  module Explain
    class FileNormalizer
      def call
        TacticInfo.all_elements.each.with_index(&method(:normalize_one))
      end

      private

      def normalize_one(elem, index)
        if file = elem.sample_kif_or_ki2_file
          info = Parser.parse(file.read)
          new_file = file.sub_ext(".kif") # ki2 だった場合を考慮する
          new_file.write(info.to_kif)
          puts "[#{index.next} / #{TacticInfo.all_elements.size}] #{new_file}"
        end
      end
    end
  end
end
