require "#{__dir__}/setup"

Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
Bioshogi::SystemSupport.strict_system("ruby -e '1 / 0'") rescue $! # => #<StandardError: -e:1:in `/': divided by 0 (ZeroDivisionError)
# ~> 	from -e:1:in `<main>'>
# ~> _xmp_1633324084_66982_297190
# >> [execute] ruby -e '1 / 0'
# >> [execute] status: pid 67040 exit 1
# >> [execute] elapsed: 3s
# >> [execute] stderr: -e:1:in `/': divided by 0 (ZeroDivisionError)
# >> 	from -e:1:in `<main>'
# >>
