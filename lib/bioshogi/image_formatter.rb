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
        # required
        width: 1200,                   # 画像横幅
        height: 630,                   # 画像縦幅
        board_rate: 0.96,              # 縦横幅の小さい方に対する盤の寸法の割合
        font_size: 0.75,               # 文字の大きさの割合(割合はすべてセルの大きさを1.0とする)
        stand_piece_line_height: 0.95, # 持駒と持駒の間隔割合
        stand_piece_count_gap: 0.6,    # 持駒と駒数の間隔の割合
        piece_pull_down_rate: {        # 盤上の駒の位置を下げる割合
          black: 0.06,
          white: 0.01,
        },
        piece_pull_right_rate: {       # 盤上の駒の位置を右に寄せる割合(これは理論的には不要だけど拡大すると気になるので少し右に寄せる)
          black: 0.05,
          white: 0.0,
        },
        star_size: 0.03,               # 星のサイズ(割合)
        canvas_color: "white",         # 下地の色(必須)
        piece_color: "black",          # 駒の色(必須)
        lattice_stroke_width: 1,       # 格子の線のドット数

        normal_font: "#{__dir__}/RictyDiminished-Regular.ttf", # 駒のフォント(普通)
        bold_font: "#{__dir__}/RictyDiminished-Bold.ttf",      # 駒のフォント(太字) (nilなら normal_font を代用)

        # optional
        piece_count_color: "#888",     # *駒数の色(nilなら piece_color を代用)
        lattice_color: "#888",         # *格子の色(nilなら piece_color を代用)
        promoted_color: "red",         # *成駒の色(nilなら piece_color を代用)
        frame_stroke_width: 2,         # 格子の外枠の線のドット数(nil なら lattice_stroke_width を代用)
        moving_color: "#f0f0f0",       # 移動元と移動先のセルの背景色(nilなら描画ない)
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
      @canvas ||= -> {
        # canvas = Magick::Image.new(*image_rect)
        # if params[:canvas_color]
        #   canvas.background_color = params[:canvas_color]
        # end
        # canvas.background_color = "blue"
        # canvas

        # https://github.com/rmagick/rmagick/issues/699
        canvas = Magick::ImageList.new
        params = self.params   # FIXME: new_image のブロック内スコープが Image.new のなかなので params が参照できないため
        canvas.new_image(*image_rect) do |e|
          e.background_color = params[:canvas_color]
        end
        canvas

        # list = Magick::ImageList.new
        # list.new_image(*image_rect)
        # list.last.background_color = "red" # params[:canvas_color]
        # list
      }.call
    end

    private

    def lattice_color
      params[:lattice_color] || params[:piece_color]
    end

    def lattice_draw
      draw_context do |c|
        c.stroke(lattice_color)
        c.stroke_width(lattice_stroke_width)

        (1...lattice.w).each do |x|
          line_draw(c, V[x, 0], V[x, lattice.h])
        end

        (1...lattice.h).each do |y|
          line_draw(c, V[0, y], V[lattice.w, y])
        end
      end
    end

    def frame_draw
      if frame_stroke_width
        draw_context do |c|
          c.stroke(lattice_color)
          c.stroke_width(frame_stroke_width)
          c.stroke_linejoin("round") # 曲がり角を丸める
          c.fill = "transparent"
          c.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h]))
        end
      end
    end

    def star_draw
      draw_context do |c|
        c.stroke("transparent")
        c.fill(lattice_color)

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
              color = params[:promoted_color] || params[:piece_color]
            else
              color = params[:piece_color]
            end
            bold = hand_log && soldier == hand_log.soldier

            v2 = v
            v2 += V[0, 1] * params[:piece_pull_down_rate][soldier.location.key]  * soldier.location.value_sign # 下に少し下げる
            v2 += V[1, 0] * params[:piece_pull_right_rate][soldier.location.key] * soldier.location.value_sign # 右に少し寄せる
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

    def char_draw(pos:, text:, rotation:, color: params[:piece_color], bold: false)
      c = Magick::Draw.new
      c.rotation = rotation
      # c.font_weight = Magick::BoldWeight # 効かない
      c.pointsize = real_pointsize
      if bold
        c.font = params[:bold_font] || params[:normal_font]
      else
        c.font = params[:normal_font]
      end
      c.stroke = "transparent"
      # c.stroke_antialias(false) # 効かない？
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
            char_draw(pos: pos, text: count.to_s, rotation: location.angle, color: params[:piece_count_color] || params[:piece_color]) # 駒数
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

    def lattice_stroke_width
      params[:lattice_stroke_width]
    end

    def frame_stroke_width
      params[:frame_stroke_width] || lattice_stroke_width
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
