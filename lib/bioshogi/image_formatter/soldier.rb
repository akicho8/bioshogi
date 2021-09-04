module Bioshogi
  class ImageFormatter
    concerning :Soldier do
      included do
        default_params.update({
          })
      end

      def soldier_draw
        cell_walker do |v|
          if soldier = mediator.board.lookup(v)
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
            color ||= params[:normal_piece_color_map][soldier.piece.key] || params[:piece_font_color]
            piece_pentagon_draw(v: v, location: location, piece: soldier.piece)
            bold ||= params[:font_board_piece_bold]
            char_draw(v: piece_char_adjust(v, location), text: soldier_name(soldier), location: location, color: color, bold: bold, font_size: soldier_char_scale(soldier.piece))
          end
        end
      end

      def moving_draw
        if params[:piece_move_cell_fill_color]
          if hand_log
            draw_context do |g|
              g.stroke("transparent")
              g.fill = params[:piece_move_cell_fill_color]
              cell_draw(g, current_place)
              cell_draw(g, origin_place)
            end
          end
        end
      end

      def char_draw(v:, text:, location:, font_size:, color: params[:piece_font_color], bold: false, stroke_width: nil, stroke_color: nil, gravity: Magick::CenterGravity)
        g = Magick::Draw.new
        g.rotation = location.angle
        # g.font_weight = Magick::BoldWeight # 効かない
        g.pointsize = cell_w * font_size

        if bold
          font = params[:font_bold] || params[:font_regular]
        else
          font = params[:font_regular]
        end

        if font
          g.font = font
        end

        # g.stroke = "transparent"  # 下手に縁取り色をつけると汚くなる
        # g.stroke_antialias = false # 効いてない

        if stroke_width && stroke_color
          g.stroke_width = stroke_width
          g.stroke       = stroke_color
          # g.stroke_linejoin("miter") # round miter bevel
          # g.stroke_linejoin("round") # round miter bevel
          # g.stroke_linejoin("bevel") # round miter bevel
        end

        # g.stroke = "rgba(255,255,255,0.9)"
        # g.stroke_width = 3

        g.fill = color

        # g.text_antialias(true)          # 効いてない
        g.gravity = gravity # annotate で指定した w, h の中心に描画する
        g.annotate(@canvas, *cell_rect, *px(v), text) # annotate(image, w, h, x, y, text)
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

      def soldier_char_scale(piece)
        params[:soldier_char_scale] * piece.scale
      end
    end
  end
end
