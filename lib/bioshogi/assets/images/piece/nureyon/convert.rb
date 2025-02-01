require "rmagick"

[
  # black
  { key: "BK0", from: "BX0", flip: false, }, # 玉
  { key: "BR0", from: "BR0", flip: false, }, # 飛
  { key: "BR1", from: "BR1", flip: false, }, # 龍
  { key: "BB0", from: "BB0", flip: false, }, # 角
  { key: "BB1", from: "BB1", flip: false, }, # 馬
  { key: "BG0", from: "BG0", flip: false, }, # 金
  { key: "BS0", from: "BS0", flip: false, }, # 銀
  { key: "BS1", from: "BS1", flip: false, }, # 成銀
  { key: "BN0", from: "BN0", flip: false, }, # 桂
  { key: "BN1", from: "BN1", flip: false, }, # 成桂
  { key: "BL0", from: "BL0", flip: false, }, # 香
  { key: "BL1", from: "BL1", flip: false, }, # 成香
  { key: "BP0", from: "BP0", flip: false, }, # 歩
  { key: "BP1", from: "BP1", flip: false, }, # と
  # white
  { key: "WK0", from: "BK0", flip: true,  }, # 王
  { key: "WR0", from: "BR0", flip: true,  }, # 飛
  { key: "WR1", from: "BR1", flip: true,  }, # 龍
  { key: "WB0", from: "BB0", flip: true,  }, # 角
  { key: "WB1", from: "BB1", flip: true,  }, # 馬
  { key: "WG0", from: "BG0", flip: true,  }, # 金
  { key: "WS0", from: "BS0", flip: true,  }, # 銀
  { key: "WS1", from: "BS1", flip: true,  }, # 成銀
  { key: "WN0", from: "BN0", flip: true,  }, # 桂
  { key: "WN1", from: "BN1", flip: true,  }, # 成桂
  { key: "WL0", from: "BL0", flip: true,  }, # 香
  { key: "WL1", from: "BL1", flip: true,  }, # 成香
  { key: "WP0", from: "BP0", flip: true,  }, # 歩
  { key: "WP1", from: "BP1", flip: true,  }, # と
].each do |e|
  in_file  = "svg/#{e[:from]}.svg"
  out_file = "#{e[:key]}.png"
  system "rsvg-convert -o #{out_file} #{in_file}" # rmagick で svg を扱うと単色なるし、なにより png の100倍ほど遅い
  if e[:flip]
    image = Magick::Image.read(out_file).first
    image = image.rotate(180)
    image.write(out_file)
  end
end
