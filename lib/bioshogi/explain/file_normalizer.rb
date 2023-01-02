module Bioshogi
  module Explain
    class FileNormalizer
      def call
        TacticInfo.all_elements.each do |e|
          dir = Pathname("#{__dir__}/#{e.tactic_info.name}")
          file = dir.glob("#{e.key}.{kif,ki2}").first
          file = file.expand_path
          if file
            info = Parser.parse(file.read)
            new_file = dir.join(file.sub_ext(".kif"))
            new_file.write(info.to_kif)
            puts new_file
          end
        end
      end
    end
  end
end
