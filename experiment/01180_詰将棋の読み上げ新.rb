require "./setup"

info = Parser.parse(<<~EOT)
後手の持駒：金
+------+
|v金v玉|
| 金 金|
+------+
先手の持駒：金2銀
EOT
info.to_yomiage_list            # => [{:command=>"talk", :message=>"gyokugata"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"いちいちgyoku"}, {:command=>"interval", :sleep=>1.0, :sleep_key=>:sep2}, {:command=>"talk", :message=>"にぃいちkin"}, {:command=>"interval", :sleep=>1.0, :sleep_key=>:sep2}, {:command=>"talk", :message=>"せめかた"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"いちにぃkin"}, {:command=>"interval", :sleep=>1.0, :sleep_key=>:sep2}, {:command=>"talk", :message=>"にぃにぃkin"}, {:command=>"interval", :sleep=>1.0, :sleep_key=>:sep2}, {:command=>"talk", :message=>"もちごま"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"kin"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"kin"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"銀"}]
tp info.to_yomiage_list

info = Parser.parse("position sfen 9/9/9/9/9/9/9/9/9 b - 1")
info.to_yomiage_list            # => [{:command=>"talk", :message=>"gyokugata"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"なし"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"せめかた"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"なし"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"もちごま"}, {:command=>"interval", :sleep=>0.5, :sleep_key=>:sep1}, {:command=>"talk", :message=>"なし"}]
tp info.to_yomiage_list

# >> |----------+---------------+-------+-----------|
# >> | command  | message       | sleep | sleep_key |
# >> |----------+---------------+-------+-----------|
# >> | talk     | gyokugata     |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | いちいちgyoku |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | にぃいちkin   |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | せめかた      |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | いちにぃkin   |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | にぃにぃkin   |       |           |
# >> | interval |               |   1.0 | sep2      |
# >> | talk     | もちごま      |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | kin           |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | kin           |       |           |
# >> | interval |               |   0.5 | sep1      |
# >> | talk     | 銀            |       |           |
# >> |----------+---------------+-------+-----------|
# >> |----------+-----------+-------+-----------|
# >> | command  | message   | sleep | sleep_key |
# >> |----------+-----------+-------+-----------|
# >> | talk     | gyokugata |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | なし      |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | せめかた  |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | なし      |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | もちごま  |       |           |
# >> | interval |           |   0.5 | sep1      |
# >> | talk     | なし      |       |           |
# >> |----------+-----------+-------+-----------|
