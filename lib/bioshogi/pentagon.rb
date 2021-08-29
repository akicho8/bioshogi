# 五角形の駒

module Bioshogi
  module Pentagon
    def self.prepended(klass)
      klass.default_params.update({
          # 駒用
          :piece_pentagon_draw          => false,             # 駒の形を描画するか？
          :piece_pentagon_fill_color    => "transparent",     # ☗の色
          :piece_pentagon_stroke_color  => nil,               # ☗の縁取り色(nilなら lattice_color を代用)
          :piece_pentagon_stroke_width  => nil,               # ☗の縁取り幅(nilなら lattice_stroke_width を代用)
          :piece_pentagon_scale         => 0.85,              # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる

          # 影
          :shadow_pentagon_draw         => false,             # ☗の影を描画するか？
          :shadow_pentagon_fill_color   => "rgba(0,0,0,0.1)", # ☗の影の色
          :shadow_pentagon_stroke_color => nil,               # ☗の影の縁取り色(nilなら shadow_pentagon_fill_color を代用)
          :shadow_pentagon_stroke_width => 3,                 # ☗の影の縁取り幅。増やすと滲みやすい
          :shadow_pentagon_scale        => nil,               # ☗の影の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる
          :shadow_pentagon_level        => 0.03,              # 影の大きさ。右下方向にずらす度合い

          # 先後
          :face_pentagon_stroke_color   => nil,               # ☗の縁取り色(nilなら lattice_color を代用)
          :face_pentagon_stroke_width   => nil,               # ☗の縁取り幅(nilなら lattice_stroke_width を代用)
          :face_pentagon_scale          => 0.6,               # ☗の大きさ 1.0 なら元のまま。つまりセルの横幅まで広がる

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

    def piece_pentagon_draw(v:, location:)
      if params[:piece_pentagon_draw]
        shadow_pentagon_draw(v: v, location: location, scale: piece_pentagon_scale)

        # pentagon_box_debug(v)
        draw_context do |g|
          w = params[:piece_pentagon_stroke_width] || lattice_stroke_width
          if w && w.nonzero?
            g.stroke(params[:piece_pentagon_stroke_color] || lattice_color)
            g.stroke_width(w)
          end
          g.fill(params[:piece_pentagon_fill_color])
          g.polygon(*pentagon_real_points(v: v, location: location, scale: piece_pentagon_scale))
        end
      end
    end

    def shadow_pentagon_draw(v:, location:, scale:)
      # if params[:piece_pentagon_draw]
      # pentagon_box_debug(v)
      draw_context do |g|
        w = params[:shadow_pentagon_stroke_width]
        if w && w.nonzero?
          g.stroke(shadow_pentagon_stroke_color)
          g.stroke_width(w)
        end
        g.fill(params[:shadow_pentagon_fill_color])
        g.translate(*(cell_rect * params[:shadow_pentagon_level]))
        g.polygon(*pentagon_real_points(v: v, location: location, scale: scale))
      end
      # end
    end

    # ☗を白黒で塗り分ける
    def face_pentagon_draw(v:, location:)
      shadow_pentagon_draw(v: v, location: location, scale: face_pentagon_scale)
      draw_context do |g|
        g.stroke(face_pentagon_stroke_color)
        g.stroke_width(face_pentagon_stroke_width)
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
            x * cell_size_w * 0.5,
            y * cell_size_h * 0.5,
          ]
        end
      }.call
    end

    ################################################################################ piece

    def piece_pentagon_scale
      params[:piece_pentagon_scale]
    end

    ################################################################################ turn

    def face_pentagon_scale
      params[:face_pentagon_scale] || piece_pentagon_scale
    end

    def face_pentagon_stroke_color
      params[:face_pentagon_stroke_color] || lattice_color
    end

    def face_pentagon_stroke_width
      params[:face_pentagon_stroke_width] || lattice_stroke_width
    end

    def face_pentagon_color(location)
      params[:face_pentagon_color][location.key]
    end

    ################################################################################ shadow

    def shadow_pentagon_stroke_color
      params[:shadow_pentagon_stroke_color] || params[:shadow_pentagon_fill_color]
    end

    def shadow_pentagon_scale
      params[:shadow_pentagon_scale] || piece_pentagon_scale
    end
  end
end
