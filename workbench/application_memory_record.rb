require "#{__dir__}/setup"

class Foo
  include Bioshogi::ApplicationMemoryRecord
  memory_record []
end

Foo.fetch(:x) rescue $! # => #<Bioshogi::KeyNotFound:"Foo.fetch(:x) does not match anything\nkeys: []\ncodes: []">
