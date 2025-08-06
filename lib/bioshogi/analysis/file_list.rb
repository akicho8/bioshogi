module Bioshogi
  module Analysis
    class FileList
      include Enumerable

      def each(&block)
        path = Bioshogi::ROOT.join("../../2chkifu").expand_path
        files = path.glob("**/*.ki2").sort
        files.each(&block)
      end
    end
  end
end
