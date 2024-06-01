require "rmagick"
require "pathname"

class App
  def run
    @canvas = Magick::Image.read("netscape:").first
    @canvas.resize!(800, 600)

    sw = @canvas.columns
    sh = @canvas.rows

    w = 300
    h = 360

    ex_piece(sw * 0.25, sh * 0.5, w, h, sign: +1.0, scale: 0.8)
    ex_piece_draw2(sw * 0.25, sh * 0.5, w, h)
    ex_piece(sw * 0.75, sh * 0.5, w, h, sign: -1.0, scale: 0.8)
    ex_piece_draw2(sw * 0.75, sh * 0.5, w, h)

    @canvas.write("_output1.png")
    `open _output1.png`
  end

  def ex_piece(cx, cy, w, h, sign: 1.0, scale: 0.8)
    points = ex_points.collect do |x, y|
      [
        cx + x * scale * w * 0.5 * sign,
        cy + y * scale * h * 0.5 * sign,
      ]
    end
    gc = Magick::Draw.new
    gc.stroke_width(3)
    gc.stroke("#00F")
    gc.fill("#0084")
    gc.polygon(*points.flatten)
    gc.draw(@canvas)
  end

  def ex_piece_draw2(cx, cy, w, h)
    gc = Magick::Draw.new
    gc.stroke_width(3)
    gc.stroke("#000")
    gc.fill("#0004")
    gc.rectangle(*[
        cx - w / 2,
        cy - h / 2,
        cx + w / 2,
        cy + h / 2,
      ])
    gc.draw(@canvas)
  end

  def ex_points
    munenaga = 0.7 # 胸長
    katahaba = 0.8 # 肩幅
    asinaga  = 1.0 # 臍下
    hunbari  = 1.0 # ふんばり片幅
    kaonaga  = 1.0 # 顔の長さ
    points = []
    points << [0.0,        -kaonaga] # 頂点
    points << [-katahaba, -munenaga] # 左肩
    points << [-hunbari,   +asinaga] # 左後
    points << [+hunbari,   +asinaga] # 右後
    points << [+katahaba, -munenaga] # 右肩
    points
  end
end

App.new.run
