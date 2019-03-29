# frozen-string-literal: true

require "pathname"

module Bioshogi
  class XtraPattern < Hash
    @list = []
    @load_paths = []
    @load_paths << Pathname(__FILE__).dirname.join("contrib/other_files/[0-9]*.rb").expand_path

    class << self
      attr_accessor :list, :load_paths

      def each(&block)
        @list.each(&block)
      end

      def store(objects)
        @list += Array.wrap(objects).collect { |e| new(e) }
      end

      def define(&block)
        store(block.call)
      end

      def reload_all
        @list.clear
        @load_paths.each do |path|
          Pathname.glob(path).sort.each { |file| load file }
        end
      end
    end

    def initialize(object)
      replace(object)
    end
  end
end
