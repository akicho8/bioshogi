module Bioshogi
  module ScreenImage
    concern :Stand do
      class_methods do
        def default_params
          super.merge({
              # 全体
              :stand_board_gap             => 0.25,              # 盤と駒台の隙間(1.0 = 1セル幅)

              # 持駒
              :stand_piece_line_height     => 1.0,               # 持駒の高さ(1.0 = 1セル高)
              :stand_piece_font_scale      => nil,               # 持駒(nil なら soldier_font_scale を代用)
              :stand_piece_font_bold       => false,             # 持駒を太くする？

              # 持駒数
              :piece_count_bg_color        => "hsla(0,0%,100%,0.7)", # 駒数の背景
              :piece_count_font_color      => "hsla(0,0%,  0%,0.7)", # *駒数の色(nilなら piece_font_color を代用)
              :piece_count_font_scale      => 0.6,               # 持駒数の大きさ
              :piece_count_stroke_color    => nil,               # 持駒数の縁取り色
              :piece_count_stroke_width    => nil,               # 持駒数の縁取り太さ
              :piece_count_bold            => nil,               # 持駒数のフォントを bold タイプにするか？
              :piece_count_position_adjust => {                  # 駒数の位置
                :single                    => [0.7, 0.05],       # 駒数1桁のとき。[0, 0] なら該当の駒の中央
                :double                    => [0.8, 0.05],       # 駒数2桁のとき
              },

              :piece_count_bg_scale        => 0,              # 駒数の背景の大きさ 0:なし 1.0:セルの半分
              # :piece_count_bg_adjust => {                     # 駒数の背景の微調整
              #   :black => [0.0, 0.0],
              #   :white => [0.0, 0.0],
              # },
            })
        end
      end

      def stand_draw
        g = params[:stand_piece_line_height]

        container.players.each do |player|
          location = player.location
          s = location.sign_dir

          if player.location.key == :black
            v = v_bottom_right_outer
          else
            v = v_top_left_outer
          end

          h = V[0, player.piece_box.count] * g       # 駒数に対応した高さ
          v -= h * s                                 # 右下から右端中央にずらす
          v += V[params[:stand_board_gap], 0] * s    # 盤と持駒の隙間を開ける

          face_pentagon_draw(v: v, location: location) # ☗☖

          v += V[0, 1] * g * s

          player.piece_box.each.with_index do |(piece_key, count), i|
            piece = Piece.fetch(piece_key)

            if params[:piece_image_key]
              soldier = Soldier.create(location: location, piece: piece, promoted: false, place: Place.zero)
              piece_image_draw(v: v, soldier: soldier)
            else
              # 持駒の影
              piece_pentagon_draw(v: v, location: location, piece: piece)

              # 持駒
              char_draw(
                  :layer      => @d_piece_layer,
                  :v          => v + piece_char_adjust(location),
                  :text       => piece.name,
                  :location   => location,
                  :color      => params[:stand_piece_color] || params[:piece_font_color],
                  :font_scale => (params[:stand_piece_font_scale] || params[:soldier_font_scale]) * piece.scale,
                  :bold       => params[:stand_piece_font_bold]
                )
            end

            # 持駒数
            piece_count_draw(v: v, count: count, location: location)
            v += V[0, 1] * g * s
          end
        end
      end

      # 駒数
      def piece_count_draw(v:, count:, location:)
        if count >= 2
          w = count <= 9 ? :single : :double
          v = v + V[*params[:piece_count_position_adjust][w]] * location.sign_dir
          piece_count_bg_draw(v: v, location: location)
          char_draw(
            :layer        => @d_piece_count_layer,
            :v            => v,
            :text         => count.to_s,
            :location     => location,
            :color        => params[:piece_count_font_color] || params[:piece_font_color], # 地べたに描画するのでコントラスト比を下げるの重要
            :font_scale   => params[:piece_count_font_scale],
            :stroke_color => params[:piece_count_stroke_color],
            :stroke_width => params[:piece_count_stroke_width],
            :bold         => params[:piece_count_bold],
            )
        end
      end

      # 駒数の下の丸
      def piece_count_bg_draw(v:, location:)
        if params[:piece_count_bg_color] && params[:piece_count_bg_scale].nonzero?
          draw_context(@d_piece_count_layer) do |g|
            g.fill(params[:piece_count_bg_color])

            # v2 = v + V[*params[:piece_count_bg_adjust][w]] * location.sign_dir
            # v2 = v + (V.half + V[*params[:piece_count_bg_adjust]]) * location.sign_dir
            # g.ellipse(*px(v2), *(cell_rect * params[:piece_count_bg_scale] * location.sign_dir), 0, 360) # x, y, w, h, angle(0 to 360)
            # g.ellipse(*px(v2), *cell_rect, 0, 360) # x, y, w, h, angle(0 to 360)

            # 個数は左上を原点とした枠の中心(CenterGravity)で表示するのでその位置に移動する
            from = v + V.half                                               # 中心に移動
            # from += V[*params[:piece_count_bg_adjust][location.key]] # 微調整
            # fromを基点として大きさを決める
            to = from + V.half * params[:piece_count_bg_scale]
            g.circle(*px(from), *px(to)) # (x1, y1) と (x2, y2) の2点を通る円

            # roundrectangle でも円風にできるけど原点が左上なので半径の調整が難しい

            # ellipse より roundrectangle の方が扱いやすい？
            # g.roundrectangle(*px(v + V.one * 0.25), *px(v + V.one), *(cell_rect * 0.25))
            # roundrectangle2(g, v)
            # g.rectangle(*px(v), *px(v + V.one * params[:piece_count_bg_scale] * s)) # debug
          end
        end
      end
    end
  end
end
