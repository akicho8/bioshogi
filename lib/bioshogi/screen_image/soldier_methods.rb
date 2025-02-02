module Bioshogi
  module ScreenImage
    concern :SoldierMethods do
      def soldier_draw_all
        container.board.soldiers.each(&method(:soldier_draw))                                                                                # 駒を描画
      end

      def soldier_draw(soldier)
        if piece_image_info
          soldier_draw_by_image(soldier)
        else
          soldier_draw_by_char(soldier)
        end
      end

      def soldier_draw_by_char(soldier)
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

        piece_pentagon_draw(v: v, location: location, piece: soldier.piece) # ☗☖

        char_draw(
          :layer     => @d_piece_layer,
          :v         => v + piece_char_adjust(location),
          :text      => soldier_name(soldier),
          :location  => location,
          :color     => color || params[:normal_piece_color_map][soldier.piece.key] || params[:piece_font_color],
          :bold      => bold || params[:soldier_font_bold],
          :font_scale => soldier_font_scale(soldier.piece),
          )
      end

      def soldier_draw_by_image(soldier)
        v = V[*soldier.place.to_xy]
        piece_image_draw(v: v, soldier: soldier)
      end

      def piece_image_draw(v:, soldier:)
        piece_path = piece_image_info.piece_path(soldier)
        scale = params[:piece_image_scale] || piece_image_info.default_scale
        wh = (cell_rect * scale).collect(&:ceil)               # => [105, 114]
        cache_key = [piece_path, wh.join("x")].join(",")       # => "nureyon/BP0,105x114"

        @piece_image_draw ||= {}
        image = @piece_image_draw[cache_key] ||= yield_self do
          full_path = ASSETS_DIR.join("images/piece/#{piece_path}.#{piece_image_info.ext_name}")
          image = Magick::Image.read(full_path).first
          image.resize_to_fill(*wh)                            # 描画領域の大きさに調整(縮小)させる
        end

        top_left = V.one * (1.0 - scale) / 2 # スケールが 0.8 なら左上から右下方向に 0.1 の位置から描画すればセルの真ん中に配置できる
        @d_piece_layer.composite!(image, *px(v + top_left), Magick::OverCompositeOp)
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
          g.font = font.to_s
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
          "王"                  # FIXME: ハードコーディングすんな
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
          if hand_log.hand.kind_of?(Hand::Move)
            V[*hand_log.hand.origin_soldier.place.to_xy]
          end
        end
      end

      # フォントの位置を微調整
      def piece_char_adjust(location)
        @piece_char_adjust ||= {}
        @piece_char_adjust[location.key] ||= V[*params[:piece_char_adjust][location.key]] * location.sign_dir
      end

      def soldier_font_scale(piece)
        params[:soldier_font_scale] * piece.scale
      end
    end
  end
end
