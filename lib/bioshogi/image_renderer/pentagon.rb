# 五角形の駒

module Bioshogi
  class ImageRenderer
    concerning :Pentagon do
      included do
        default_params.update({
            # 駒用
            :piece_pentagon_draw          => false,             # 駒の形を描画するか？(trueにしたらpiece_font_scaleを調整すること)
            :pt_file       => nil,               # ☗のテクスチャ(あれば piece_pentagon_fill_color より優先)
            :piece_pentagon_fill_color    => "transparent",     # ☗の色 ()
            :piece_pentagon_stroke_color  => "transparent",     # ☗の縁取り色
            :piece_pentagon_stroke_width  => 1,                 # ☗の縁取り幅
            :piece_pentagon_scale         => 0.85,              # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる

            # :piece_pentagon_scale_map     => {
            #   :king    => 0.85,
            #   :rook    => 0.85,
            #   :bishop  => 0.85,
            #   :gold    => 0.85,
            #   :silver  => 0.85,
            #   :knight  => 0.85,
            #   :lance   => 0.85,
            #   :pawn    => 0.50,
            # },

            # # 影
            # :shadow_pentagon_draw         => false,              # ☗の影を描画するか？
            # :shadow_pentagon_fill_color   => "hsla(0,0%,0%,0.35)", # ☗の影の色
            # # :shadow_pentagon_stroke_color => nil,               # ☗の影の縁取り色(nilなら shadow_pentagon_fill_color を代用)
            # # :shadow_pentagon_stroke_width => 3,                 # ☗の影の縁取り幅。増やすと滲みやすい
            # :shadow_pentagon_scale        => nil,               # ☗の影の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる
            # :shadow_pentagon_level        => 0.03,              # 影の大きさ。右下方向にずらす度合い

            # 先後
            :face_pentagon_stroke_color   => nil,               # ☗の縁取り色(nilなら piece_pentagon_stroke_color を代用)
            :face_pentagon_stroke_width   => nil,               # ☗の縁取り幅(nilなら piece_pentagon_stroke_width を代用)
            :face_pentagon_scale          => 0.7,               # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる
            :face_pentagon_color          => {
              :black                      => "rgba(  0,  0,  0,0.7)",     # ☗を白と黒で塗り分けるときの先手の色
              :white                      => "rgba(255,255,255,0.7)",     # ☗を白と黒で塗り分けるときの後手の色
            },

            # 六角形のスタイル
            #
            #              |katahaba|   ----------------------
            #             ／＼                         ↓
            #            ／  ＼                     kaonaga
            #          ／     ＼                       ↑
            #         ／       ＼                      ｜
            #       ／          ＼      ___________    ｜
            #      |              |      ↓            ｜
            #     |                 |   munenaga       ｜
            #     |                 |    ↑            ｜
            #    |        ●         |  ----------------------- 高さの中心
            #   |                    |   ↓
            #  |                     |  asinaga
            # |                       |  ↑
            # +-----------------------+ ---------
            #             |→hunbari←|
            #
            # 1.0 = 半径相当 (横方向ならセル横幅/2で縦方向ならセル高さ/2)
            # すべて中心からの相対距離
            # 全体に対して *_scale でスケールする
            #
            :pentagon_profile => {
              :munenaga => 0.7,  # 胸長
              :katahaba => 0.76, # 肩幅(ふんばり幅と差が少ないと寸胴に見える)
              :asinaga  => 1.0,  # 臍下
              :hunbari  => 0.95, # ふんばり幅(1.0にするとデブに見える)
              :kaonaga  => 1.0,  # 顔の長さ
            },
          })
      end

      def piece_pentagon_draw(v:, location:, piece: nil)
        if params[:piece_pentagon_draw]
          # shadow_pentagon_draw(v: v, location: location, scale: piece_pentagon_scale(piece))

          # pentagon_box_debug(v)
          draw_context(@d_piece_layer) do |g|
            w = params[:piece_pentagon_stroke_width]
            if w && w.nonzero?
              g.stroke(params[:piece_pentagon_stroke_color])
              g.stroke_width(w)
            end
            if @s_pattern_layer
              g.fill_pattern = @s_pattern_layer
            end
            g.fill(params[:piece_pentagon_fill_color])
            g.polygon(*pentagon_real_points(v: v, location: location, scale: piece_pentagon_scale(piece)))
          end
        end
      end

      # def shadow_pentagon_draw(v:, location:, scale:)
      #   if params[:shadow_pentagon_draw]
      #     raise "使用禁止"
      #
      #     # pentagon_box_debug(v)
      #     draw_context do |g|
      #       # NOTE: stroke すると fill した端を縁取って予想より濃くなり調整が難しくなるため取る
      #       # if false
      #       #   w = params[:shadow_pentagon_stroke_width]
      #       #   if w && w.nonzero?
      #       #     g.stroke(shadow_pentagon_stroke_color)
      #       #     g.stroke_width(w)
      #       #   end
      #       # end
      #       g.fill(params[:shadow_pentagon_fill_color])
      #       g.translate(*(cell_rect * params[:shadow_pentagon_level]))
      #       g.polygon(*pentagon_real_points(v: v, location: location, scale: scale))
      #     end
      #   end
      # end

      # ☗を白黒で塗り分ける
      def face_pentagon_draw(v:, location:)
        # shadow_pentagon_draw(v: v, location: location, scale: face_pentagon_scale)
        draw_context(@d_piece_layer) do |g|
          if face_pentagon_stroke_width
            g.stroke(face_pentagon_stroke_color)
            g.stroke_width(face_pentagon_stroke_width)
          end
          g.fill(face_pentagon_color(location))
          g.polygon(*pentagon_real_points(v: v, location: location, scale: face_pentagon_scale))
        end
      end

      def pentagon_box_debug(v)
        draw_context do |g|
          g.stroke_width(1)
          g.stroke("#000")
          g.fill("transparent")
          g.rectangle(*px(v), *px(v + V.one))
        end
      end

      # 実座標化
      # OPTIMIZE: cx, cy を除いた部分だけキャッシュした方がよくない？
      def pentagon_real_points(v:, location:, scale: 1.0)
        cx, cy = *px(v + V.half)  # 中央
        pentagon_points.flat_map do |x, y|
          [
            cx + x * scale * location.value_sign,
            cy + y * scale * location.value_sign,
          ]
        end
      end

      # 相対座標で☖の一周分
      # pentagon_real_points の方で行う計算で固定のものはこちらで先に行っておく
      def pentagon_points
        @pentagon_points ||= -> {
          e = params[:pentagon_profile]
          [
            [0.0,            -e[:kaonaga]],  # 頂点
            [-e[:katahaba],  -e[:munenaga]], # 左肩
            [-e[:hunbari],   +e[:asinaga]],  # 左後
            [+e[:hunbari],   +e[:asinaga]],  # 右後
            [+e[:katahaba],  -e[:munenaga]], # 右肩
          ].collect do |x, y|
            [
              x * cell_w * 0.5,
              y * cell_h * 0.5,
            ]
          end
        }.call
      end

      ################################################################################ piece

      def piece_pentagon_scale(piece)
        params[:piece_pentagon_scale] * piece.scale
        # params[:piece_pentagon_scale_map].fetch(piece.key, )
      end

      ################################################################################ turn

      def face_pentagon_scale
        params[:face_pentagon_scale] || piece_pentagon_scale
      end

      def face_pentagon_stroke_color
        params[:face_pentagon_stroke_color] || params[:piece_pentagon_stroke_color]
      end

      def face_pentagon_stroke_width
        params[:face_pentagon_stroke_width] || params[:piece_pentagon_stroke_width]
      end

      def face_pentagon_color(location)
        params[:face_pentagon_color][location.key]
      end

      ################################################################################ shadow

      # def shadow_pentagon_stroke_color
      #   params[:shadow_pentagon_stroke_color] || params[:shadow_pentagon_fill_color]
      # end

      # def shadow_pentagon_scale
      #   params[:shadow_pentagon_scale] || piece_pentagon_scale
      # end

      ################################################################################

      def pattern_layer_create
        if v = params[:pt_file].presence
          Magick::Image.read(Pathname(v).expand_path).first
        end
      end
    end
  end
end
