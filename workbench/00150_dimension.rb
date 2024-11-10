require "./setup"

Place.fetch([-1, 0]) rescue $!  # => #<Bioshogi::SyntaxDefact: 座標が読み取れません : [-1, 0]>

Dimension.wh_change([2, 2]) do
  BoardParser.parse(<<~EOT).soldiers.collect(&:name).sort # => ["▲２一歩"]
+------+
| 歩 ・|
+------+
    EOT
end

Dimension::DimensionColumn.fetch("１").object_id == Dimension::DimensionColumn.fetch("１").object_id # => true

instance = Dimension::DimensionColumn.fetch("１")
instance.name           # => "１"
instance.value          # => 8
instance.hankaku_number # => "1"
instance.zenkaku_number # => "１"
instance.to_sfen        # => "1"
instance.to_human_int   # => 1
instance.yomiage        # => "いち"

instance = Dimension::DimensionRow.fetch("１")
instance.name           # => "一"
instance.value          # => 0
instance.hankaku_number # => "1"
instance.zenkaku_number # => "１"
instance.to_sfen        # => "a"
instance.to_human_int   # => 1
instance.yomiage        # => "いち"

test_methods = [
  :name,
  :value,
  :hankaku_number,
  :zenkaku_number,
  :to_sfen,
  :to_human_int,
  :yomiage,
]

test = -> klass {
  tp klass.dimension.times.collect { |e|
    instance = klass.fetch(e)
    test_methods.inject({}) { |a, m|
      a.merge(m => instance.public_send(m))
    }
  }
}
test.(Dimension::DimensionColumn)
test.(Dimension::DimensionRow)
# >> ["/Users/ikeda/src/bioshogi/lib/bioshogi/place.rb:44", :lookup, [nil, #<Bioshogi::Dimension::DimensionRow:70178848317620 "一" 0>]]
# >> |------+-------+----------------+----------------+---------+--------------+---------|
# >> | name | value | hankaku_number | zenkaku_number | to_sfen | to_human_int | yomiage |
# >> |------+-------+----------------+----------------+---------+--------------+---------|
# >> | ９   |     0 |              9 | ９             |       9 |            9 | きゅう  |
# >> | ８   |     1 |              8 | ８             |       8 |            8 | はち    |
# >> | ７   |     2 |              7 | ７             |       7 |            7 | なな    |
# >> | ６   |     3 |              6 | ６             |       6 |            6 | ろく    |
# >> | ５   |     4 |              5 | ５             |       5 |            5 | ごー    |
# >> | ４   |     5 |              4 | ４             |       4 |            4 | よん    |
# >> | ３   |     6 |              3 | ３             |       3 |            3 | さん    |
# >> | ２   |     7 |              2 | ２             |       2 |            2 | にぃ    |
# >> | １   |     8 |              1 | １             |       1 |            1 | いち    |
# >> |------+-------+----------------+----------------+---------+--------------+---------|
# >> |------+-------+----------------+----------------+---------+--------------+---------|
# >> | name | value | hankaku_number | zenkaku_number | to_sfen | to_human_int | yomiage |
# >> |------+-------+----------------+----------------+---------+--------------+---------|
# >> | 一   |     0 |              1 | １             | a       |            1 | いち    |
# >> | 二   |     1 |              2 | ２             | b       |            2 | にぃ    |
# >> | 三   |     2 |              3 | ３             | c       |            3 | さん    |
# >> | 四   |     3 |              4 | ４             | d       |            4 | よん    |
# >> | 五   |     4 |              5 | ５             | e       |            5 | ごー    |
# >> | 六   |     5 |              6 | ６             | f       |            6 | ろく    |
# >> | 七   |     6 |              7 | ７             | g       |            7 | なな    |
# >> | 八   |     7 |              8 | ８             | h       |            8 | はち    |
# >> | 九   |     8 |              9 | ９             | i       |            9 | きゅう  |
# >> |------+-------+----------------+----------------+---------+--------------+---------|
