# 五角形の駒

module Bioshogi
  module ScreenImage
    concern :Pentagon do
      class_methods do
        def default_params
          super.merge({
              # 駒用
              :piece_pentagon_draw         => false,             # 駒の形を描画するか？(trueにしたらpiece_font_scaleを調整すること)
              :pt_file                     => nil,               # ☗のテクスチャ(あれば piece_pentagon_fill_color より優先)
              :piece_pentagon_fill_color   => "transparent",     # ☗の色 ()
              :piece_pentagon_stroke_color => "transparent",     # ☗の縁取り色
              :piece_pentagon_stroke_width => 1,                 # ☗の縁取り幅
              :piece_pentagon_scale        => 0.85,              # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる

              # 先後
              :face_pentagon_stroke_color   => "hsla(0,0%,50%)",  # ☗の縁取り色(nilなら piece_pentagon_stroke_color を代用)
              :face_pentagon_stroke_width   => 3,                 # ☗の縁取り幅(nilなら piece_pentagon_stroke_width を代用)
              :face_pentagon_scale          => 0.7,               # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる
              :face_pentagon_color          => {                  # ☗を白と黒で塗り分けるときの色
                :black => {
                  :fill   => "hsl(0,0%,5%)",
                  :stroke => "hsl(0,0%,20%)",
                },
                :white => {
                  :fill   => "hsl(0,0%,95%)",
                  :stroke => "hsl(0,0%,80%)",
                },
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
      end

      def piece_pentagon_draw(v:, location:, piece: nil)
        if params[:piece_pentagon_draw]
          # pentagon_box_debug(v)
          draw_context(@d_piece_layer) do |g|
            w = params[:piece_pentagon_stroke_width]
            if w && w.nonzero?
              g.stroke(params[:piece_pentagon_stroke_color])
              g.stroke_width(w)
            end
            if @s_pattern_layer
              g.fill_pattern = @s_pattern_layer # テクスチャが足りない場合は繰り返し敷き詰められる。だいたい64pxあればよい。余裕を見て 128x128 で作ろう
            end
            g.fill(params[:piece_pentagon_fill_color])
            g.polygon(*pentagon_real_points(v: v, location: location, scale: piece_pentagon_scale(piece)))
          end
        end
      end

      # ☗を白黒で塗り分ける
      def face_pentagon_draw(v:, location:)
        draw_context(@d_piece_layer) do |g|
          color = face_pentagon_color(location)
          w = face_pentagon_stroke_width
          if w && w.nonzero?
            g.stroke(color[:stroke] || params[:piece_pentagon_stroke_color])
            g.stroke_width(w)
          end
          g.fill(color[:fill])
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
            cx + x * scale * location.sign_dir,
            cy + y * scale * location.sign_dir,
          ]
        end
      end

      # 相対座標で☖の一周分
      # pentagon_real_points の方で行う計算で固定のものはこちらで先に行っておく
      def pentagon_points
        @pentagon_points ||= yield_self do
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
        end
      end

      ################################################################################ piece

      def piece_pentagon_scale(piece)
        params[:piece_pentagon_scale] * piece.scale
      end

      ################################################################################ turn

      def face_pentagon_scale
        params[:face_pentagon_scale] || piece_pentagon_scale
      end

      def face_pentagon_stroke_width
        params[:face_pentagon_stroke_width] || params[:piece_pentagon_stroke_width]
      end

      def face_pentagon_color(location)
        params[:face_pentagon_color][location.key]
      end

      ################################################################################

      def pattern_layer_create
        if v = params[:pt_file].presence
          Magick::Image.read(Pathname(v).expand_path).first
        end
      end
    end
  end
end
