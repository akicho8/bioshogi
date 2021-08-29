module Bioshogi
  class ImageFormatter
    concerning :Stand do
      included do
        default_params.update({
            # 全体
            :stand_board_gap => 0.25,          # 盤と駒台の隙間(1.0 = 1セル幅)

            # 持駒
            :stand_piece_line_height => 1.0,   # 持駒の高さ(1.0 = 1セル高)
            :stand_piece_char_scale  => nil,   # 持駒(nil なら piece_char_scale を代用)

            # 持駒数
            :piece_count_color        => "rgba(0,0,0,0.8)",   # *駒数の色(nilなら piece_color を代用)
            :piece_count_scale        => 0.6,  # 持駒数の大きさ
            :piece_count_stroke_color => nil,  # 持駒数の縁取り色
            :piece_count_stroke_width => nil,  # 持駒数の縁取り太さ
            :piece_count_position_adjust => {  # 駒数の位置
              :single => [0.7, 0.05],          # 駒数1桁のとき。[0, 0] なら該当の駒の中央
              :double => [0.8, 0.05],          # 駒数2桁のとき
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

          pentagon_mark = location.pentagon_mark

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
    end
  end
end
