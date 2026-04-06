require "#{__dir__}/setup"

Place.fetch([-1, 0]) rescue $!  # => #<Bioshogi::SyntaxDefact: 座標が読み取れません : [-1, 0]>

Dimension.change([2, 2]) do
  BoardParser.parse(<<~EOT).soldiers.collect(&:name).sort # => ["▲２一歩"]
+------+
| 歩 ・|
+------+
    EOT
end

Dimension::Column.fetch("１").object_id == Dimension::Column.fetch("１").object_id # => true

instance = Dimension::Column.fetch("１")
instance.name           # => "１"
instance.value          # => 8
instance.hankaku_number # => "1"
instance.zenkaku_number # => 
instance.to_sfen        # => 
instance.human_int   # => 

instance = Dimension::Row.fetch("１")
instance.name           # => 
instance.value          # => 
instance.hankaku_number # => 
instance.zenkaku_number # => 
instance.to_sfen        # => 
instance.human_int   # => 

test_methods = [
  :name,
  :value,
  :hankaku_number,
  :zenkaku_number,
  :to_sfen,
  :human_int,
  :yomiage,
]

test = -> klass {
  tp klass.dimension_size.times.collect { |e|
    instance = klass.fetch(e)
    test_methods.inject({}) { |a, m|
      a.merge(m => instance.public_send(m))
    }
  }
}
test.(Dimension::Column)
test.(Dimension::Row)
# ~> -:19:in '<main>': undefined method 'zenkaku_number' for an instance of Bioshogi::Dimension::Column (NoMethodError)
# ~> Did you mean?  hankaku_number
