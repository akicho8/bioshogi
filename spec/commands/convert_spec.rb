require "spec_helper"

module Bioshogi
  module Commands
    describe Convert do
      it "works" do
        output_file = Pathname("#{__dir__}/../../tmp/sample.ki2")
        output_file.existence&.delete
        files = ["#{__dir__}/../../lib/bioshogi/assets/kifu_formats/sample.kif"]
        options = { format: "ki2", output_dir: "#{__dir__}/../../tmp" }
        capture(:stdout) { Convert.new(files, options).call }
        assert { output_file.exist? }
      end
    end
  end
end
