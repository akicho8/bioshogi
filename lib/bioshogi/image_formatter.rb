# ・PNGに限定させてはいけない

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
        # 0.95 * (33.3 / 36.4) = 0.8690934065934065
        :aspect_ratio_w => 0.8690934065934065, # 縦横幅の小さい方に対する盤の横幅の割合(横長の場合縦比率より小さめにする)
        :aspect_ratio_h => 0.95,               # 縦横幅の小さい方に対する盤の縦幅の割合(横長の場合1.0にすると縦の隙間がなくなる)

        # 文字の大きさの割合
        # ※割合はすべてセルの大きさを1.0とする
        :piece_char_scale         => 0.85, # 盤上駒
        :stand_piece_char_scale   => nil,  # 持駒(nil なら piece_char_scale を代用)

        # 持駒
        :piece_count_scale        => 0.6,  # 持駒数の大きさ
        :piece_count_stroke_color => nil,  # 持駒数の縁取り色
        :piece_count_stroke_width => nil,  # 持駒数の縁取り太さ

        # 隙間割合
        :piece_stand_margin      => 0.25, # 持駒と盤面
        :stand_piece_line_height => 1.0,  # 持駒と持駒
        :piece_count_position_adjust => { # 駒数の位置
          :single => [0.7, 0.1],          # 駒数1桁のとき。[0, 0] なら該当の駒の中央
          :double => [0.8, 0.1],          # 駒数2桁のとき
        },

        ################################################################################
        # REVIEW: 見直す必要がある
        # 本当はやりたくない微調整
        # 盤上の駒の位置を下げる割合
        :piece_char_adjust => {
          :black => [0.0425, 0.07],
          :white => [0.0,    0.01],
        },
        ################################################################################

        # 盤
        :canvas_color         => "white",           # 部屋の色(必須)
        :piece_color          => "rgba(0,0,0,0.8)", # 駒の色(必須)
        :star_size            => 0.03,              # 星のサイズ(割合)
        :outer_frame_padding  => 0,                 # 盤の余白
        :lattice_stroke_width => 1,                 # 格子の線の太さ
        :inner_frame_stroke_width   => 3,                 # 枠の線お太さ(nil なら lattice_stroke_width を代用)
        :dimension_w          => Dimension::Xplace.dimension, # 横のセル数
        :dimension_h          => Dimension::Yplace.dimension, # 縦のセル数

        # optional
        :last_soldier_color => nil,                 # *最後に動いた駒の色。基本指定しない。(nilなら piece_color を代用)
        :stand_piece_color  => nil,                 # *持駒の色(nilなら piece_color を代用)
        :piece_count_color  => "rgba(0,0,0,0.8)",   # *駒数の色(nilなら piece_color を代用)
        :lattice_color      => "rgba(0,0,0,0.3)",   # *格子の色(nilなら piece_color を代用)
        :star_color         => nil,                 # *星の色(nilなら lattice_color を代用)
        :inner_frame_color  => "rgba(0,0,0,0.3)",   # *格子の外枠色(nilなら piece_color を代用) これだけで全体イメージが変わる超重要色
        :promoted_color     => "rgba(255,0,0,0.8)", # *成駒の色(nilなら piece_color を代用)
        :frame_bg_color     => "transparent",       # 盤の色
        :cell_colors        => nil,                 # セルの色 複数指定可
        :moving_color       => "rgba(0,0,0,0.05)",  # 移動元と移動先のセルの背景色(nilなら描画しない)
        :normal_piece_color_map => {},              # 成ってない駒それぞれの色(nilなら piece_color を代用)

        :normal_font => "#{__dir__}/RictyDiminished-Regular.ttf", # 駒のフォント(普通)
        :bold_font   => "#{__dir__}/RictyDiminished-Bold.ttf",    # 駒のフォント(太字) (nilなら normal_font を代用)
        :force_bold => false,  # 常に太字を使うか？

        # :normal_font => "/Users/ikeda/Downloads/KsShogiPieces/KsShogiPieces.ttf", # 駒のフォント(普通)

        # other
        :viewpoint    => "black",  # 視点
        :image_format => "png",    # 出力する画像タイプ
        :negate       => false,    # 反転
        :bg_file      => nil,      # 背景ファイル
        :canvas_cache => false,    # リサイズ後の背景をキャッシュするか？ (インスタンスを維持したまま連続で生成する場合に有用)

        # :pentagon_fill => false,    # ☗を塗り潰して後手を表現するか？ (背景が黒い場合に認識が逆になってしまう対策だけど微妙)
        :pentagon_color => {
          :black => "rgba(  0,  0,  0,0.6)",        # ☗を白と黒で塗り分けるときの先手の色
          :white => "rgba(255,255,255,0.6)",  # ☗を白と黒で塗り分けるときの後手の色
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
        stand_draw
      end

      lattice_draw
      inner_frame_draw
      star_draw                 # 星は必ず最後

      canvas_flip_if_viewpoint_is_white

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
      if @canvas_cache
        @canvas = @canvas_cache.copy
        return
      end

      case
      when true
        # @canvas = Magick::Image.read("logo:").first
        @canvas = Magick::Image.read(Pathname("#{__dir__}/assets/images/matrix_1024x768.png")).first
        @canvas = Magick::Image.read(Pathname("~/Pictures/ぱくたそ/IS107112702_TP_V.jpg").expand_path).first
        @canvas.resize!(*image_rect) # 200 ms
        # @canvas.blur_image(20.0, 10.0)
        # @canvas = @canvas.emboss
        canvas_flip_if_viewpoint_is_white # 全体を反転するので背景だけ反転しておくことで元に戻る
      when v = params[:bg_file]
        @canvas = Magick::Image.read(v).first
        # @canvas.resize_to_fit!(*image_rect)  # 指定したサイズより(画像が小さいと)画像のサイズになる
        # @canvas.resize_to_fill!(*image_rect) # アス比を維持して中央を切り取る
        @canvas.resize!(*image_rect) # 200 ms
        canvas_flip_if_viewpoint_is_white # 全体を反転するので背景だけ反転しておくことで元に戻る
      else
        @canvas = Magick::Image.new(*image_rect) do |e|
          e.background_color = params[:canvas_color]
        end
      end

      if params[:canvas_cache]
        @canvas_cache = @canvas.copy
      end
    end

    # # 変化がない部分
    # def static_draw
    #   frame_bg_draw
    #   lattice_draw
    #   inner_frame_draw
    # end

    # 格子色
    def lattice_color
      params[:lattice_color] || params[:piece_color]
    end

    def star_color
      params[:star_color] || lattice_color
    end

    def inner_frame_color
      params[:inner_frame_color] || params[:piece_color]
    end

    # line で stroke を使うと fill + stroke で二重に同じところを塗るっぽい
    # だから半透明にしても濃くなる
    # なので fill だけにする
    def lattice_draw
      draw_context do |c|
        c.fill(lattice_color)

        # c.stroke(lattice_color)
        # c.stroke_width(lattice_stroke_width)

        (1...lattice.w).each do |x|
          line_draw(c, V[x, 0], V[x, lattice.h])
        end

        (1...lattice.h).each do |y|
          line_draw(c, V[0, y], V[lattice.w, y])
        end
      end
    end

    def inner_frame_draw
      if inner_frame_stroke_width
        draw_context do |c|
          c.stroke(inner_frame_color)
          c.stroke_width(inner_frame_stroke_width)
          c.stroke_linejoin("round") # 曲がり角を丸める 動いてない？
          c.fill = "transparent"
          c.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h])) # stroke_width に応じてずれる心配なし
        end
      end
    end

    def frame_bg_draw
      draw_context do |c|
        if false
          c.stroke(inner_frame_color)
          c.stroke_width(inner_frame_stroke_width)
        end
        c.fill = params[:frame_bg_color]
        d = V.one * params[:outer_frame_padding]
        c.rectangle(*px(V[0, 0] - d), *px(V[lattice.w, lattice.h] + d)) # stroke_width に応じてずれる心配なし
      end

      if v = params[:cell_colors].presence
        colors = Array(v).cycle
        cell_walker do |v|
          color = colors.next
          if color
            draw_context do |c|
              c.fill = color
              c.rectangle(*px(v), *px(v + V.one))
            end
          end
        end
      end
    end

    def star_draw
      draw_context do |c|
        c.stroke("transparent")
        c.fill(star_color)

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
      cell_walker do |v|
        if soldier = mediator.board.lookup(v)
          location = soldier.location
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
          piece_pentagon_draw(v: v, location: location)
          char_draw(v: adjust(v, location), text: soldier_name(soldier), location: location, color: color, bold: bold, font_size: params[:piece_char_scale])
        end
      end
    end

    def canvas_flip_if_viewpoint_is_white
      if params[:viewpoint].to_s == "white"
        @canvas.rotate!(180) # 5 ms
      end
    end

    # draw の時点で最後に指定した fill が使われる
    def draw_context
      c = Magick::Draw.new
      yield c
      c.draw(@canvas)
    end

    def cell_walker
      lattice.h.times do |y|
        lattice.w.times do |x|
          yield V[x, y]
        end
      end
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

    def char_draw(v:, text:, location:, font_size:, color: params[:piece_color], bold: false, stroke_width: nil, stroke_color: nil, gravity: Magick::CenterGravity)
      c = Magick::Draw.new
      c.rotation = location.angle
      # c.font_weight = Magick::BoldWeight # 効かない
      c.pointsize = cell_size_w * font_size
      if params[:force_bold] || bold
        c.font = params[:bold_font] || params[:normal_font]
      else
        c.font = params[:normal_font]
      end

      # c.stroke = "transparent"  # 下手に縁取り色をつけると汚くなる
      # c.stroke_antialias = false # 効いてない

      if stroke_width && stroke_color
        c.stroke_width = stroke_width
        c.stroke       = stroke_color
        # c.stroke_linejoin("miter") # round miter bevel
        # c.stroke_linejoin("round") # round miter bevel
        # c.stroke_linejoin("bevel") # round miter bevel
      end

      # c.stroke = "rgba(255,255,255,0.9)"
      # c.stroke_width = 3

      c.fill = color

      # c.text_antialias(true)          # 効いてない
      c.gravity = gravity # annotate で指定した w, h の中心に描画する
      c.annotate(@canvas, *cell_size_rect, *px(v), text) # annotate(image, w, h, x, y, text)
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
        v += V[params[:piece_stand_margin], 0] * s # 盤と持駒の隙間を開ける

        pentagon_mark = location.pentagon_mark

        if false
          if params[:pentagon_fill]
            # 背景が黒い場合に認識が逆になってしまうので☗を白と黒で塗り分ける場合
            char_draw(v: adjust(v, location), text: "☗", location: location, color: params[:pentagon_color][location.key]) # ▲
          else
            char_draw(v: adjust(v, location), text: pentagon_mark, location: location) # ▲
          end
        else
          turn_pentagon_draw(v: v, location: location)
        end

        v += V[0, 1] * g * s

        player.piece_box.each.with_index do |(piece_key, count), i|
          piece = Piece.fetch(piece_key)
          # 持駒の影
          piece_pentagon_draw(v: v, location: location)
          # 持駒
          char_draw({
              :v         => adjust(v, location),
              :text      => piece.name,
              :location  => location,
              :color     => params[:stand_piece_color] || params[:piece_color],
              :font_size => params[:stand_piece_char_scale] || params[:piece_char_scale],
            })
          # 持駒数
          if count >= 2
            w = count <= 9 ? :single : :double
            char_draw({
                :v            => v + V[*params[:piece_count_position_adjust][w]] * s,
                :text         => count.to_s,
                :location     => location,
                :color        => params[:piece_count_color] || params[:piece_color],
                :font_size    => params[:piece_count_scale],
                :stroke_color => params[:piece_count_stroke_color],
                :stroke_width => params[:piece_count_stroke_width],
                # :gravity      => Magick::WestGravity,
              })
          end
          v += V[0, 1] * g * s
        end
      end
    end

    def soldier_name(soldier)
      if soldier.piece.key == :king && soldier.location.key == :black
        "王"
      else
        soldier.any_name
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

    def inner_frame_stroke_width
      params[:inner_frame_stroke_width] || lattice_stroke_width
    end

    def image_format
      params[:image_format].presence or raise ArgumentError, "params[:image_format] is blank"
    end

    def ext_name
      image_format
    end

    # フォントの位置を微調整
    def adjust(v, location)
      v + V.one.map2(params[:piece_char_adjust][location.key]) { |a, b| a * b * location.value_sign }
    end

    prepend Pentagon
  end
end
