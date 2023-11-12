$LOAD_PATH.unshift(File.expand_path("..", __dir__))

require "bioshogi"
require "thor"

module Bioshogi
  class CLI < Thor
    class_option :debug, type: :boolean
    class_option :quiet, type: :boolean

    include Converter::CLI
    include Ai::Versus::CLI
  end

  Pathname(__dir__).glob("cli/*.rb").each { |e| require e }
end

if $0 == __FILE__
  Bioshogi::CLI.start
end
