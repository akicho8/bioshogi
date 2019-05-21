require "matrix"

# parser = Parser.parse(<<~EOT, turn_limit: 10)
# 後手の持駒：飛二 角 銀二 桂四 香四 歩九
#   ９ ８ ７ ６ ５ ４ ３ ２ １
# +---------------------------+
# | ・ ・ ・ ・ ・ ・ ・ ・v玉|一
# | ・ ・ ・ ・ ・ ・ ・ 竜 ・|二
# | ・ ・ ・ ・ ・ ・ ・ 歩 ・|三
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|四
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|五
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|六
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|七
# | ・ ・ ・ ・ ・ ・ ・ ・ ・|八
# | ・ ・ ・ ・ 玉 ・ ・ ・ ・|九
# +---------------------------+
# 先手の持駒：角 金四 銀二 歩九
#
# ６四角打
# ５三角打
# 32竜
# EOT
#
# object = parser.image_formatter
# object.display

module Bioshogi
  class ImageFormatter
    cattr_accessor :default_params do
      {
        width: 1600,                   # 画像横幅
        height: 630,                   # 画像縦幅
        board_rate: 0.96,              # 縦横幅の小さい方に対する盤の寸法の割合
        # normal_font: "Meiryo",         # 駒のフォント
        normal_font: "/Users/ikeda/Library/Fonts/Ricty-Regular.ttf",
        bold_font: "MeiryoB",          # 駒のフォント(ボールド)
        font_size: 0.6,                # 文字の大きさの割合(割合はすべてセルの大きさを1.0とする)
        stand_piece_line_height: 0.95, # 持駒と持駒の間隔割合
        stand_piece_count_gap: 0.6,    # 持駒と駒数の間隔の割合
        piece_pull_rate: 0.1,          # 盤上の位置を下げる割合
        star_size: 0.03,               # 星のサイズ(割合)
        paper_color: "white",          # 下地の色
        piece_name_color: "black",     # 駒の色
        piece_count_color: "           #888",     # 駒数の色
        lattice_color: "               #888",         # 格子の色
        promoted_color: "red",         # 成駒の色
        lattice_stroke_width: 1,       # 格子の線のドット数
        frame_stroke_width: 2,         # 格子の外枠の線のドット数
        moving_color: "                #f0f0f0",       # 移動元と移動先のセルの背景色(falseなら描画しない)
      }
    end

    cattr_accessor(:star_step) { 3 }

    class << self
      def render(*args)
        new(*args).tap(&:render)
      end
    end

    attr_accessor :parser
    attr_accessor :params

    def initialize(parser, **params)
      require "rmagick"

      @parser = parser
      @params = default_params.merge(params)
      @rendered = false
    end

    def render
      if @rendered
        return
      end

      moving_draw
      piece_draw
      lattice_draw
      star_draw
      frame_draw
      stand_draw

      @rendered = true
    end

    def to_png
      canvas.format = "png"
      canvas.to_blob
    end

    def display
      require "tmpdir"
      file = "#{Dir.tmpdir}/#{Time.now.strftime('%Y%m%m%H%M%S')}_#{SecureRandom.hex}.png"
      canvas.write(file)
      system "open #{file}"
    end

    def canvas
      @canvas ||= Magick::ImageList.new.tap do |canvas|
        canvas.new_image(*image_rect).tap do |e|
          e.background_color = params[:paper_color]
        end
      end
    end

    private

    def lattice_draw
      draw_context do |c|
        c.stroke(params[:lattice_color])
        c.stroke_width(params[:lattice_stroke_width])

        lattice.w.next.times do |x|
          line_draw(c, V[x, 0], V[x, lattice.h])
        end

        lattice.h.next.times do |y|
          line_draw(c, V[0, y], V[lattice.w, y])
        end
      end
    end

    def frame_draw
      draw_context do |c|
        c.stroke(params[:lattice_color])
        c.stroke_width(params[:frame_stroke_width])
        c.stroke_linejoin("round") # 曲がり角を丸める
        c.fill = "transparent"
        c.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h]))
      end
    end

    def star_draw
      draw_context do |c|
        c.stroke("transparent")
        c.fill(params[:lattice_color])

        i = star_step
        (i...lattice.w).step(i) do |x|
          (i...lattice.h).step(i) do |y|
            v = V[x, y]
            c.circle(*px(v), *px(v + V.one * params[:star_size]))
          end
        end
      end
    end

    def moving_draw
      if hand_log
        if params[:moving_color]
          draw_context do |c|
            c.stroke("transparent")
            c.fill = params[:moving_color]
            cell_draw(c, current_place)
            cell_draw(c, origin_place)
          end
        end
      end
    end

    def piece_draw
      lattice.h.times do |y|
        lattice.w.times do |x|
          v = V[x, y]
          if soldier = parser.mediator.board.lookup(v)
            if soldier.promoted
              color = params[:promoted_color]
            else
              color = params[:piece_name_color]
            end
            bold = hand_log && soldier == hand_log.soldier
            v2 = v + V[0, 1] * params[:piece_pull_rate] * soldier.location.value_sign
            char_draw(pos: v2, text: soldier.any_name, rotation: soldier.location.angle, color: color, bold: bold)
          end
        end
      end
    end

    def draw_context
      c = Magick::Draw.new
      yield c
      c.draw(canvas)
    end

    def px(v)
      top_left + v * cell_size
    end

    def line_draw(c, v1, v2)
      c.line(*px(v1), *px(v2))
    end

    def cell_draw(c, v)
      if v
        c.rectangle(*px(v), *px(v + V.one))
      end
    end

    def char_draw(pos:, text:, rotation:, color: params[:piece_name_color], bold: false)
      c = Magick::Draw.new
      c.rotation = rotation
      c.pointsize = real_pointsize
      if bold
        c.font = params[:bold_font]
      else
        c.font = params[:normal_font]
      end
      c.stroke = "transparent"
      # c.stroke_width = 2
      # c.stroke_antialias(true)
      c.fill = color
      c.gravity = Magick::CenterGravity
      c.annotate(canvas, *cell_size_rect, *px(pos), text)
    end

    def stand_draw
      g = params[:stand_piece_line_height]

      parser.mediator.players.each do |player|
        location = player.location
        s = location.value_sign

        if player.location.key == :black
          v = v_bottom_right_outer
        else
          v = v_top_left_outer
        end

        h = V[0, player.piece_box.count] * g # 駒数に対応した高さ
        v -= h * s                           # 右下から右端中央にずらす

        char_draw(pos: v, text: location.hexagon_mark, rotation: location.angle) # ▲
        v += V[0, 1] * g * s

        player.piece_box.each.with_index do |(piece_key, count), i|
          piece = Bioshogi::Piece.fetch(piece_key)
          char_draw(pos: v, text: piece.name, rotation: location.angle)  # 駒
          if count > 1
            pos = v + V[params[:stand_piece_count_gap], 0] * s
            char_draw(pos: pos, text: count.to_s, rotation: location.angle, color: params[:piece_count_color]) # 駒数
          end
          v += V[0, 1] * g * s
        end
      end
    end

    def hand_log
      @hand_log ||= parser.mediator.hand_logs.last
    end

    def current_place
      if hand_log
        soldier = hand_log.soldier
        V[*hand_log.soldier.place.to_xy]
      end
    end

    def origin_place
      if hand_log
        if hand_log.hand.kind_of?(Bioshogi::MoveHand)
          V[*hand_log.hand.origin_soldier.place.to_xy]
        end
      end
    end

    def real_pointsize
      @real_pointsize ||= cell_size * params[:font_size]
    end

    def image_rect
      @image_rect ||= Rect[params[:width], params[:height]]
    end

    def lattice
      @lattice ||= Rect[*Bioshogi::Dimension.dimension_wh]
    end

    def cell_size
      @cell_size ||= (vmin * params[:board_rate]) / lattice.h
    end

    def vmin
      @vmin ||= image_rect.to_a.min
    end

    def cell_size_rect
      @cell_size_rect ||= Rect[cell_size, cell_size]
    end

    def center
      @center ||= V[canvas.columns / 2, canvas.rows / 2]
    end

    def top_left
      @top_left ||= center - lattice * cell_size / 2
    end

    def v_bottom_right_outer
      @v_bottom_right_outer ||= V[lattice.w, lattice.h - 1]
    end

    def v_top_left_outer
      @v_top_left_outer ||= V[-1, 0]
    end

    class V < Vector
      def self.one
        self[1, 1]
      end

      def x
        self[0]
      end

      def y
        self[1]
      end
    end

    class Rect < Vector
      def w
        self[0]
      end

      def h
        self[1]
      end
    end
  end
end
