module Bioshogi
  class ImageRenderer
    concerning :SoldierMethods do
      included do
        default_params.update({
          })
      end

      def soldier_draw_all
        mediator.board.soldiers.each(&method(:soldier_draw))                                                                                # 駒を描画
      end

      def soldier_draw(soldier)
        v = V[*soldier.place.to_xy]
        location = soldier.location
        color = nil
        bold = false

        if hand_log && soldier == hand_log.soldier
          color ||= params[:last_soldier_font_color]
          bold = true
        end

        if soldier.promoted
          color ||= params[:promoted_font_color]
        end

        piece_pentagon_draw(v: v, location: location, piece: soldier.piece)

        char_draw({
            :layer     => @d_piece_layer,
            :v         => piece_char_adjust(v, location),
            :text      => soldier_name(soldier),
            :location  => location,
            :color     => color || params[:normal_piece_color_map][soldier.piece.key] || params[:piece_font_color],
            :bold      => bold || params[:font_board_piece_bold],
            :font_scale => soldier_font_scale(soldier.piece),
          })
      end

      def soldier_move_cell_draw
        if params[:piece_move_cell_fill_color]
          if hand_log
            draw_context(@d_move_layer) do |g|
              g.stroke("transparent")
              g.fill = params[:piece_move_cell_fill_color]
              cell_draw(g, current_place)
              cell_draw(g, origin_place)
            end
          end
        end
      end

      def char_draw(layer: nil, v:, text:, location:, font_scale:, color: params[:piece_font_color], bold: false, stroke_width: nil, stroke_color: nil)
        g = Magick::Draw.new
        g.rotation = location.angle
        g.pointsize = cell_w * font_scale

        font = nil
        if bold
          font = params[:font_bold]
        end
        font ||= params[:font_regular]

        if font
          g.font = font
        end

        if stroke_width && stroke_color
          g.stroke_width = stroke_width
          g.stroke       = stroke_color
        end

        g.fill = color
        g.gravity = Magick::CenterGravity # annotate で指定した範囲の中央に描画する
        g.annotate(layer, *cell_rect, *px(v), text) # annotate(image, w, h, x, y, text)
      end

      def soldier_name(soldier)
        if soldier.piece.key == :king && soldier.location.key == :white
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

      # フォントの位置を微調整
      def piece_char_adjust(v, location)
        v + V.one.map2(params[:piece_char_adjust][location.key]) { |a, b| a * b * location.value_sign }
      end

      def soldier_font_scale(piece)
        params[:soldier_font_scale] * piece.scale
      end
    end
  end
end
