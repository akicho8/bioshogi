module Bioshogi
  class ImageFormatter
    concerning :Stand do
      included do
        default_params.update({
            # 全体
            :stand_board_gap             => 0.25,              # 盤と駒台の隙間(1.0 = 1セル幅)

            # 持駒
            :stand_piece_line_height     => 1.0,               # 持駒の高さ(1.0 = 1セル高)
            :stand_piece_char_scale      => nil,               # 持駒(nil なら piece_char_scale を代用)
            :font_stand_piece_bold      => false,             # 持駒を太くする？

            # 持駒数
            :piece_count_color           => "rgba(0,0,0,0.8)", # *駒数の色(nilなら piece_color を代用)
            :piece_count_scale           => 0.6,               # 持駒数の大きさ
            :piece_count_stroke_color    => nil,               # 持駒数の縁取り色
            :piece_count_stroke_width    => nil,               # 持駒数の縁取り太さ
            :piece_count_position_adjust => {                  # 駒数の位置
              :single                    => [0.7, 0.05],       # 駒数1桁のとき。[0, 0] なら該当の駒の中央
              :double                    => [0.8, 0.05],       # 駒数2桁のとき
            },

            :piece_count_bg_scale         => 0,                       # 駒数の背景の大きさ
            :piece_count_bg_color         => "rgba(255,255,255,0.5)", # 駒数の背景
            :piece_count_bg_adjust => {                     # 駒数の背景の微調整
              :black => [0.0, 0.0],
              :white => [0.0, 0.0],
            },
          })
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
          v += V[params[:stand_board_gap], 0] * s # 盤と持駒の隙間を開ける

          face_pentagon_draw(v: v, location: location)

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
                :bold      => params[:font_stand_piece_bold]
              })

            # 持駒数
            piece_count_draw(v: v, count: count, location: location)
            v += V[0, 1] * g * s
          end
        end
      end

      def piece_count_draw(v:, count:, location:)
        if count >= 2
          w = count <= 9 ? :single : :double
          v = v + V[*params[:piece_count_position_adjust][w]] * location.value_sign
          piece_count_bg_draw(v: v, location: location)
          char_draw({
              :v            => v,
              :text         => count.to_s,
              :location     => location,
              :color        => params[:piece_count_color] || params[:piece_color], # 地べたに描画するのでコントラスト比を下げるの重要
              :font_size    => params[:piece_count_scale],
              :stroke_color => params[:piece_count_stroke_color],
              :stroke_width => params[:piece_count_stroke_width],
            })
        end
      end

      def piece_count_bg_draw(v:, location:)
        if params[:piece_count_bg_color] && params[:piece_count_bg_scale].nonzero?
          draw_context do |g|
            g.fill(params[:piece_count_bg_color])

            # v2 = v + V[*params[:piece_count_bg_adjust][w]] * location.value_sign
            # v2 = v + (V.half + V[*params[:piece_count_bg_adjust]]) * location.value_sign
            # g.ellipse(*px(v2), *(cell_rect * params[:piece_count_bg_scale] * location.value_sign), 0, 360) # x, y, w, h, angle(0 to 360)
            # g.ellipse(*px(v2), *cell_rect, 0, 360) # x, y, w, h, angle(0 to 360)

            # 個数は左上を原点とした枠の中心(CenterGravity)で表示するのでその位置に移動する
            a = v + V.half                                               # 中心に移動
            a += V[*params[:piece_count_bg_adjust][location.key]] # 微調整
            # aを基点として大きさを決める
            b = a + V.half * params[:piece_count_bg_scale]
            g.circle(*px(a), *px(b)) # (x1, y1) - (x2, y2)

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
