# ・PNGに限定させてはいけない

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
#

module Bioshogi
  class ImageFormatter < BinaryFormatter
    cattr_accessor :default_params do
      {
        # required
        :width  => 1200, # 画像横幅
        :height => 630,  # 画像縦幅

        # 将棋盤の比率は先に 0.96 を適当に決めてそこから横幅の比率を出している
        # 0.96 * (33.3 / 36.4) = 0.87824175824
        :aspect_ratio_w => 0.87824175824, # 縦横幅の小さい方に対する盤の横幅の割合(横長の場合縦比率より小さめにする)
        :aspect_ratio_h => 0.96,          # 縦横幅の小さい方に対する盤の縦幅の割合(横長の場合1.0にすると縦の隙間がなくなる)

        # 文字の大きさの割合
        # ※割合はすべてセルの大きさを1.0とする
        :font_size_piece => 0.75, # 盤上の駒
        :font_size_hold  => 0.80, # 持駒▲△
        :font_size_digit => 0.6,  # 持駒数

        # 隙間割合
        :piece_stand_margin      => 0.2,  # 持駒と盤面
        :stand_piece_line_height => 0.98, # 持駒と持駒
        :stand_piece_count_gap => {       # 持駒と駒数の間隔の割合
          :single => 0.6,                 # 駒数1桁のとき
          :double => 0.7,                 # 駒数2桁のとき
        },

        # 本当はやりたくない微調整
        # 盤上の駒の位置を下げる割合
        :piece_pull_down_rate => {
          :black => 0.06,
          :white => 0.01,
        },
        # 盤上の駒の位置を右に寄せる割合(これは理論的には不要だけど拡大すると気になるので少し右に寄せる)
        :piece_pull_right_rate => {
          :black => 0.05,
          :white => 0.0,
        },

        # 盤
        :canvas_color         => "white",   # 部屋の色(必須)
        :piece_color          => "black",   # 駒の色(必須)
        :star_size            => 0.03,      # 星のサイズ(割合)
        :lattice_stroke_width => 1,         # 格子の線の太さ
        :frame_stroke_width   => 3,         # 枠の線お太さ(nil なら lattice_stroke_width を代用)
        :dimension_w          => Dimension::Xplace.dimension, # 横のセル数
        :dimension_h          => Dimension::Yplace.dimension, # 縦のセル数

        # optional
        :last_soldier_color => nil,            # *最後に動いた駒の色。基本指定しない。(nilなら piece_color を代用)
        :stand_piece_color  => nil,            # *持駒の色(nilなら piece_color を代用)
        :piece_count_color  => "#888",         # *駒数の色(nilなら piece_color を代用)
        :lattice_color      => "#999",         # *格子の色(nilなら piece_color を代用)
        :frame_color        => "#777",         # *格子の外枠色(nilなら piece_color を代用) これだけで全体イメージが変わる超重要色
        :promoted_color     => "red",          # *成駒の色(nilなら piece_color を代用)
        :frame_bg_color     => "transparent",  # 盤の色
        :moving_color       => "#f0f0f0",      # 移動元と移動先のセルの背景色(nilなら描画しない)
        # :moving_color       => nil,          # 移動元と移動先のセルの背景色(nilなら描画しない)
        :normal_piece_color_map => {},         # 成ってない駒それぞれの色(nilなら piece_color を代用)

        :normal_font => "#{__dir__}/RictyDiminished-Regular.ttf", # 駒のフォント(普通)
        :bold_font   => "#{__dir__}/RictyDiminished-Bold.ttf",    # 駒のフォント(太字) (nilなら normal_font を代用)

        # other
        :viewpoint    => "black",  # 視点
        :image_format => "png",    # 出力する画像タイプ
        :negate       => false,    # 反転
        :bg_file      => nil,      # 背景ファイル

        :hexagon_fill => false,    # ☗を塗り潰して後手を表現するか？ (背景が黒い場合に認識が逆になってしまう対策だけど微妙)
        :hexagon_color => {
          :black => "#000",        # ☗を白と黒で塗り分けるときの先手の色
          :white => "#fff",        # ☗を白と黒で塗り分けるときの後手の色
        },
        :color_theme_key => "light_mode",
      }
    end

    cattr_accessor(:star_step) { 3 } # 星はnセルごとに書く

    class << self
      def render(*args)
        new(*args).tap(&:render)
      end
    end

    attr_accessor :mediator
    attr_accessor :params
    attr_accessor :canvas
    attr_accessor :hand_log

    def initialize(mediator, params = {})
      # params.assert_valid_keys(default_params.keys)

      @mediator = mediator
      @params = default_params.merge(params)

      if v = @params[:color_theme_key]
        @params.update(ColorThemeInfo.fetch(v).to_params)
      end

      @rendered = false
    end

    def render
      require "rmagick"

      @hand_log = mediator.hand_logs.last

      # 将棋盤の静的な部分を使いまわす
      # しかしたいして速度が変わらなかった
      # 46秒が45秒になった程度
      # しかも moving_draw によって格子が上書きされてしまうため moving_color を nil にしないとダメ
      # それならば元の方法にする
      #
      # if @templete_bg
      #   @canvas = @templete_bg.clone
      # else
      #   canvas_create
      #   static_draw
      #   if params[:use_templete]
      #     @templete_bg = @canvas.clone
      #   end
      # end

      canvas_create
      frame_bg_draw

      if true
        moving_draw
        piece_draw
        star_draw
        stand_draw
      end

      lattice_draw
      frame_draw

      if params[:viewpoint].to_s == "white"
        @canvas.rotate!(180)
      end

      if params[:negate]
        @canvas = canvas.negate
      end

      @rendered = true
    end

    def render_once
      if @rendered
        return
      end
      render
    end

    def main_canvas
      @canvas
    end

    private

    # 必ず新しく作ること
    def canvas_create
      if v = params[:bg_file]
        @canvas = Magick::Image.read(v).first
        # @canvas.resize_to_fit!(*image_rect)  # 指定したサイズより(画像が小さいと)画像のサイズになる
        # @canvas.resize_to_fill!(*image_rect) # アス比を維持して中央を切り取る
        @canvas.resize!(*image_rect)
        if params[:viewpoint].to_s == "white"
          @canvas.rotate!(180) # 全体を反転するので背景だけ反転しておくことで元に戻る
        end
      else
        @canvas = Magick::Image.new(*image_rect) do |e|
          e.background_color = params[:canvas_color]
        end
      end
    end

    # # 変化がない部分
    # def static_draw
    #   frame_bg_draw
    #   lattice_draw
    #   frame_draw
    # end

    # 格子色
    def lattice_color
      params[:lattice_color] || params[:piece_color]
    end

    def frame_color
      params[:frame_color] || params[:piece_color]
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
          c.stroke(frame_color)
          c.stroke_width(frame_stroke_width)
          c.stroke_linejoin("round") # 曲がり角を丸める 動いてない？
          c.fill = "transparent"
          c.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h])) # stroke_width に応じてずれる心配なし
        end
      end
    end

    def frame_bg_draw
      draw_context do |c|
        c.fill = params[:frame_bg_color]
        c.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h])) # stroke_width に応じてずれる心配なし
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

    # 格子を消してしまうので使わないことにする
    def moving_draw
      if params[:moving_color]
        if hand_log
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
          if soldier = mediator.board.lookup(v)
            color = nil
            if hand_log && soldier == hand_log.soldier
              color ||= params[:last_soldier_color]
              bold = true
            else
              bold = false
            end
            if soldier.promoted
              color ||= params[:promoted_color]
            end
            color ||= params[:normal_piece_color_map][soldier.piece.key] || params[:piece_color]
            v2 = v
            v2 += V[0, 1] * params[:piece_pull_down_rate][soldier.location.key]  * soldier.location.value_sign # 下に少し下げる
            v2 += V[1, 0] * params[:piece_pull_right_rate][soldier.location.key] * soldier.location.value_sign # 右に少し寄せる
            char_draw(pos: v2, text: soldier.any_name, rotation: soldier.location.angle, color: color, bold: bold, font_size: params[:font_size_piece])
          end
        end
      end
    end

    def draw_context
      c = Magick::Draw.new
      yield c
      c.draw(@canvas)
    end

    def px(v)
      # もともとセルは正方形だった
      # だから「top_left + v * cell_size_w」でよかった
      # これは w, h を同じ値で乗算する
      # するとセルが正方形になる
      # しかし実際の将棋盤は縦長なので正方形にすると心理的に押し潰された印象になってしまう
      # なので w * 90, h * 100 のような感じにしないといけない
      # [90, 100] みたいなのは cell_size_rect に入っている
      # ベクトルのそれぞれの位置を掛け算するには map2 を使う
      # https://docs.ruby-lang.org/ja/latest/class/Vector.html
      # collect2 だと Array になってしまうので注意
      # map2 を使わないのなら top_left + V[v.x * cell_size_w, v.y * cell_size_h] で良い
      # ベタな書き方をしてみたけど速度に影響なし
      # また v でメモ化してみたけどこれも影響なし
      top_left + v.map2(cell_size_rect) { |a, b| a * b }
    end

    def line_draw(c, v1, v2)
      c.line(*px(v1), *px(v2))
    end

    def cell_draw(c, v)
      if v
        c.rectangle(*px(v), *px(v + V.one))
      end
    end

    def char_draw(pos:, text:, rotation:, color: params[:piece_color], bold: false, font_size: params[:font_size_hold])
      c = Magick::Draw.new
      c.rotation = rotation
      # c.font_weight = Magick::BoldWeight # 効かない
      c.pointsize = cell_size_w * font_size
      if bold
        c.font = params[:bold_font] || params[:normal_font]
      else
        c.font = params[:normal_font]
      end
      c.stroke = "transparent"  # 下手に縁取り色をつけると汚くなる
      # c.stroke_antialias(false) # 効かない？
      c.fill = color
      c.gravity = Magick::CenterGravity
      c.annotate(@canvas, *cell_size_rect, *px(pos), text)
    end

    def stand_draw
      g = params[:stand_piece_line_height]

      mediator.players.each do |player|
        location = player.location
        s = location.value_sign

        if player.location.key == :black
          v = v_bottom_right_outer
        else
          v = v_top_left_outer
        end

        h = V[0, player.piece_box.count] * g       # 駒数に対応した高さ
        v -= h * s                                 # 右下から右端中央にずらす
        v += V[params[:piece_stand_margin], 0] * s # 盤から持駒を少し離す

        hexagon_mark = location.hexagon_mark
        if params[:hexagon_fill]
          # 背景が黒い場合に認識が逆になってしまうので☗を白と黒で塗り分ける場合
          char_draw(pos: v, text: "☗", rotation: location.angle, color: params[:hexagon_color][location.key]) # ▲
        else
          char_draw(pos: v, text: hexagon_mark, rotation: location.angle) # ▲
        end
        v += V[0, 1] * g * s

        player.piece_box.each.with_index do |(piece_key, count), i|
          piece = Piece.fetch(piece_key)
          char_draw(pos: v, text: piece.name, rotation: location.angle, color: params[:stand_piece_color] || params[:piece_color])
          if count >= 2
            if count <= 9
              w = :single
            else
              w = :double
            end
            pos = v + V[params[:stand_piece_count_gap][w], 0] * s
            char_draw(pos: pos, text: count.to_s, rotation: location.angle, color: params[:piece_count_color] || params[:piece_color], font_size: params[:font_size_digit]) # 駒数
          end
          v += V[0, 1] * g * s
        end
      end
    end

    def current_place
      if hand_log
        soldier = hand_log.soldier
        V[*hand_log.soldier.place.to_xy]
      end
    end

    def origin_place
      if hand_log
        if hand_log.hand.kind_of?(MoveHand)
          V[*hand_log.hand.origin_soldier.place.to_xy]
        end
      end
    end

    def image_rect
      @image_rect ||= Rect[params[:width], params[:height]]
    end

    def lattice
      @lattice ||= Rect[params[:dimension_w], params[:dimension_h]]
    end

    def cell_size_w
      @cell_size_w ||= (vmin * params[:aspect_ratio_w]) / lattice.w
    end

    def cell_size_h
      @cell_size_h ||= (vmin * params[:aspect_ratio_h]) / lattice.h
    end

    def vmin
      @vmin ||= image_rect.to_a.min
    end

    def cell_size_rect
      @cell_size_rect ||= Rect[cell_size_w, cell_size_h]
    end

    def center
      @center ||= V[@canvas.columns / 2, @canvas.rows / 2]
    end

    def top_left
      @top_left ||= center - cell_size_rect.map2(lattice) { |a, b| a * b } / 2
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

    def image_format
      params[:image_format].presence or raise ArgumentError, "params[:image_format] is blank"
    end

    def ext_name
      image_format
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
