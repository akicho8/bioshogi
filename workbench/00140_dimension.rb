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
instance.zenkaku_number # => "１"
instance.to_sfen        # => "1"
instance.human_int   # => 1

instance = Dimension::Row.fetch("１")
instance.name           # => "一"
instance.value          # => 0
instance.hankaku_number # => "1"
instance.zenkaku_number # => "１"
instance.to_sfen        # => "a"
instance.human_int   # => 1

test_methods = [
  :name,
  :value,
  :hankaku_number,
  :zenkaku_number,
  :to_sfen,
  :human_int,
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
# >> |------+-------+----------------+----------------+---------+-----------|
# >> | name | value | hankaku_number | zenkaku_number | to_sfen | human_int |
# >> |------+-------+----------------+----------------+---------+-----------|
# >> | ９   |     0 |              9 | ９             |       9 |         9 |
# >> | ８   |     1 |              8 | ８             |       8 |         8 |
# >> | ７   |     2 |              7 | ７             |       7 |         7 |
# >> | ６   |     3 |              6 | ６             |       6 |         6 |
# >> | ５   |     4 |              5 | ５             |       5 |         5 |
# >> | ４   |     5 |              4 | ４             |       4 |         4 |
# >> | ３   |     6 |              3 | ３             |       3 |         3 |
# >> | ２   |     7 |              2 | ２             |       2 |         2 |
# >> | １   |     8 |              1 | １             |       1 |         1 |
# >> |------+-------+----------------+----------------+---------+-----------|
# >> |------+-------+----------------+----------------+---------+-----------|
# >> | name | value | hankaku_number | zenkaku_number | to_sfen | human_int |
# >> |------+-------+----------------+----------------+---------+-----------|
# >> | 一   |     0 |              1 | １             | a       |         1 |
# >> | 二   |     1 |              2 | ２             | b       |         2 |
# >> | 三   |     2 |              3 | ３             | c       |         3 |
# >> | 四   |     3 |              4 | ４             | d       |         4 |
# >> | 五   |     4 |              5 | ５             | e       |         5 |
# >> | 六   |     5 |              6 | ６             | f       |         6 |
# >> | 七   |     6 |              7 | ７             | g       |         7 |
# >> | 八   |     7 |              8 | ８             | h       |         8 |
# >> | 九   |     8 |              9 | ９             | i       |         9 |
# >> |------+-------+----------------+----------------+---------+-----------|
