require "./setup"

require "mechanize"

agent = Mechanize.new
agent.user_agent_alias = "iPhone"
user = "hanairobiyori"

gtype = ""    # 10分
gtype = "s1"  # 10秒
gtype = "sb"  # 3分
url = "https://shogiwars.heroz.jp/users/history/#{user}?gtype=#{gtype}&locale=ja"

page = agent.get(url)
str = page.body

File.write(url.gsub(/\W/, "_") + ".html", str)

urls = str.scan(%r{//kif-pona.heroz.jp/games/.*?locale=ja})
urls = urls.collect { |e| "http:#{e}" }
urls # => ["http://kif-pona.heroz.jp/games/hanairobiyori-ispt-20171104_220810?locale=ja", "http://kif-pona.heroz.jp/games/anklesam-hanairobiyori-20171104_220223?locale=ja", "http://kif-pona.heroz.jp/games/komakoma1213-hanairobiyori-20171104_215841?locale=ja", "http://kif-pona.heroz.jp/games/hanairobiyori-mizumakura-20171104_215208?locale=ja", "http://kif-pona.heroz.jp/games/baldbull-hanairobiyori-20171104_213234?locale=ja", "http://kif-pona.heroz.jp/games/hanairobiyori-chihaya_3-20171104_212752?locale=ja", "http://kif-pona.heroz.jp/games/hanairobiyori-kazuruisena-20171104_212234?locale=ja", "http://kif-pona.heroz.jp/games/hanairobiyori-kanposs-20171104_211903?locale=ja", "http://kif-pona.heroz.jp/games/hanairobiyori-Yuki1290-20171104_211225?locale=ja", "http://kif-pona.heroz.jp/games/9271-hanairobiyori-20171026_103138?locale=ja"]
urls.size                       # => 10

url = urls.first
page = agent.get(url)
str = page.body

File.write(url.gsub(/\W/, "_") + ".html", str)

csa_like_kifu_list = str.scan(/([\+\-]\d{4}[A-Z]{2}),L\d+/)
csa_kifu = csa_like_kifu_list.flatten.join("\n")
puts Parser.parse(csa_kifu).to_ki2
# >> ▲６八銀 △３四歩 ▲５六歩   △３二金   ▲５七銀 △１四歩   ▲１六歩   △８四歩   ▲７九角 △８五歩
# >> ▲７八金 △４二銀 ▲４八銀上 △３三銀   ▲２六歩 △５二玉   ▲２五歩   △３一角   ▲６九玉 △４二角
# >> ▲３六歩 △６二銀 ▲４六銀   △７二金   ▲３五歩 △同　歩   ▲同　銀   △３四歩   ▲２四歩 △同　歩
# >> ▲同　銀 △同　銀 ▲同　角   △同　角   ▲同　飛 △２三歩   ▲２八飛   △８六歩   ▲同　歩 △同　飛
# >> ▲８七歩 △５六飛 ▲５七銀打 △３六飛   ▲３七歩 △３五飛   ▲４六銀   △８五飛   ▲３六歩 △３三銀
# >> ▲６八角 △５四歩 ▲３五歩   △同　歩   ▲同　銀 △３四歩   ▲２四歩   △同　歩   ▲同　銀 △同　銀
# >> ▲同　角 △２三歩 ▲６八角   △３三銀   ▲５八金 △９四歩   ▲９六歩   △５三銀   ▲７九玉 △４四銀右
# >> ▲５七銀 △３五銀 ▲４六銀   △同　銀   ▲同　角 △３九角   ▲１八飛   △７五角成 ▲７六銀 △同　馬
# >> ▲同　歩 △５五銀 ▲６八角   △８二飛   ▲８八玉 △２七銀   ▲４八飛   △３六銀成 ▲３七歩 △２七全
# >> ▲４九飛 △３八全 ▲７九飛   △５六銀   ▲５七歩 △４五銀   ▲７七銀   △３五歩   ▲６六歩 △３六歩
# >> ▲同　歩 △同　銀 ▲３七歩   △２七銀成 ▲５六歩 △２八全上 ▲６七金右 △２九全右 ▲３六歩 △１九全寄
# >> ▲４六角 △４四香 ▲２八角   △１八全   ▲３九角 △４七香成 ▲４九飛   △３七杏   ▲４八銀 △３八杏
# >> ▲５九飛 △３九杏 ▲同　銀   △３七角   ▲７九飛 △２六角成 ▲６八銀   △１七全   ▲３八銀 △３六馬
# >> ▲４九銀 △３七歩 ▲４八香   △２七全   ▲４七角 △３五馬   ▲５八角   △３八歩成 ▲４七香 △４九と
# >> ▲同　角 △３七全 ▲５八角   △３八歩   ▲６九角 △３九歩成 ▲５七銀   △３六馬   ▲４六銀 △４七全
# >> ▲５七銀 △４九と ▲６八銀   △４八と   ▲７七銀 △４六桂   ▲４七角   △同　馬   ▲１九飛 △５八と
# >> ▲７九銀 △５七と ▲９八玉   △６七と   ▲同　金 △５八桂成 ▲８八銀引
# >> まで167手で先手の勝ち
