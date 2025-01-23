# convert backup/WG0.png -background none -gravity north -crop 249x245+0+11 +repage -extent 249x256 WG0.png

require "rmagick"

[
  # black
  { key: "0OU", output: "BK0", shift:   0, }, # 王
  { key: "0GY", output: "BX0", shift:   0, }, # 玉
  { key: "0HI", output: "BR0", shift:   0, }, # 飛
  { key: "0RY", output: "BR1", shift:   0, }, # 龍
  { key: "0KA", output: "BB0", shift:   0, }, # 角
  { key: "0UM", output: "BB1", shift:   0, }, # 馬
  { key: "0KI", output: "BG0", shift:   0, }, # 金
  { key: "0GI", output: "BS0", shift:   0, }, # 銀
  { key: "0NG", output: "BS1", shift:   0, }, # 成銀
  { key: "0KE", output: "BN0", shift:   0, }, # 桂
  { key: "0NK", output: "BN1", shift:   0, }, # 成桂
  { key: "0KY", output: "BL0", shift:   0, }, # 香
  { key: "0NY", output: "BL1", shift:   0, }, # 成香
  { key: "0FU", output: "BP0", shift:   0, }, # 歩
  { key: "0TO", output: "BP1", shift:   0, }, # と
  # white
  { key: "1OU", output: "WK0", shift:   0, }, # 王
  { key: "1GY", output: "WX0", shift:   0, }, # 玉
  { key: "1HI", output: "WR0", shift:  -2, }, # 飛
  { key: "1RY", output: "WR1", shift:  -2, }, # 龍
  { key: "1KA", output: "WB0", shift:  -2, }, # 角
  { key: "1UM", output: "WB1", shift:  -2, }, # 馬
  { key: "1KI", output: "WG0", shift:  -7, }, # 金
  { key: "1GI", output: "WS0", shift:  -8, }, # 銀
  { key: "1NG", output: "WS1", shift:  -8, }, # 成銀
  { key: "1KE", output: "WN0", shift: -10, }, # 桂
  { key: "1NK", output: "WN1", shift: -10, }, # 成桂
  { key: "1KY", output: "WL0", shift: -11, }, # 香
  { key: "1NY", output: "WL1", shift: -11, }, # 成香
  { key: "1FU", output: "WP0", shift: -15, }, # 歩
  { key: "1TO", output: "WP1", shift: -15, }, # と
].each do |e|
  in_file = "original/#{e[:key]}.png"
  # system "identify #{in_file}"

  image = Magick::Image.read(in_file).first
  image.background_color = "transparent"
  w = image.columns
  h = image.rows

  if e[:shift].negative?
    shift = -e[:shift]
    image = image.crop(0, shift, w, h - shift)
    image = image.extent(w, h, 0, shift)
  end

  if e[:shift].positive?
    shift = e[:shift]
    image = image.crop(0, 0, w, h - shift)
    image = image.extent(w, h, 0, -shift)
  end

  output = "#{e[:output] || e[:key]}.png"
  image.write(output)
  system "identify #{output}"
  # system "open #{output}"
end
# >> BK0.png PNG 249x256 249x256+0+0 8-bit sRGB 21569B 0.000u 0:00.000
# >> BX0.png PNG 249x256 249x256+0+0 8-bit sRGB 21396B 0.000u 0:00.000
# >> BR0.png PNG 249x256 249x256+0+0 8-bit sRGB 21203B 0.000u 0:00.000
# >> BR1.png PNG 249x256 249x256+0+0 8-bit sRGB 21090B 0.000u 0:00.000
# >> BB0.png PNG 249x256 249x256+0+0 8-bit sRGB 20447B 0.000u 0:00.000
# >> BB1.png PNG 249x256 249x256+0+0 8-bit sRGB 21052B 0.000u 0:00.000
# >> BG0.png PNG 249x256 249x256+0+0 8-bit sRGB 18240B 0.000u 0:00.000
# >> BS0.png PNG 249x256 249x256+0+0 8-bit sRGB 19032B 0.000u 0:00.000
# >> BS1.png PNG 249x256 249x256+0+0 8-bit sRGB 18670B 0.000u 0:00.000
# >> BN0.png PNG 249x256 249x256+0+0 8-bit sRGB 18239B 0.000u 0:00.000
# >> BN1.png PNG 249x256 249x256+0+0 8-bit sRGB 17587B 0.000u 0:00.000
# >> BL0.png PNG 249x256 249x256+0+0 8-bit sRGB 17444B 0.000u 0:00.000
# >> BL1.png PNG 249x256 249x256+0+0 8-bit sRGB 16916B 0.000u 0:00.000
# >> BP0.png PNG 249x256 249x256+0+0 8-bit sRGB 15927B 0.000u 0:00.000
# >> BP1.png PNG 249x256 249x256+0+0 8-bit sRGB 14983B 0.000u 0:00.000
# >> WK0.png PNG 249x256 249x256+0+0 8-bit sRGB 22286B 0.000u 0:00.000
# >> WX0.png PNG 249x256 249x256+0+0 8-bit sRGB 23058B 0.000u 0:00.000
# >> WR0.png PNG 249x256 249x258+0+2 8-bit sRGB 23689B 0.000u 0:00.000
# >> WR1.png PNG 249x256 249x258+0+2 8-bit sRGB 22758B 0.000u 0:00.000
# >> WB0.png PNG 249x256 249x258+0+2 8-bit sRGB 22617B 0.000u 0:00.000
# >> WB1.png PNG 249x256 249x258+0+2 8-bit sRGB 22750B 0.000u 0:00.000
# >> WG0.png PNG 249x256 249x263+0+7 8-bit sRGB 20613B 0.000u 0:00.000
# >> WS0.png PNG 249x256 249x264+0+8 8-bit sRGB 20356B 0.000u 0:00.000
# >> WS1.png PNG 249x256 249x264+0+8 8-bit sRGB 20176B 0.000u 0:00.000
# >> WN0.png PNG 249x256 249x266+0+10 8-bit sRGB 19170B 0.000u 0:00.000
# >> WN1.png PNG 249x256 249x266+0+10 8-bit sRGB 18831B 0.000u 0:00.000
# >> WL0.png PNG 249x256 249x267+0+11 8-bit sRGB 18244B 0.000u 0:00.000
# >> WL1.png PNG 249x256 249x267+0+11 8-bit sRGB 18473B 0.000u 0:00.000
# >> WP0.png PNG 249x256 249x272+0+15 8-bit sRGB 17314B 0.000u 0:00.000
# >> WP1.png PNG 249x256 249x272+0+15 8-bit sRGB 15969B 0.000u 0:00.000
