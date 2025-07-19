module Bioshogi
  module ScreenImage
    concern :BoardMethods do
      private

      def lattice_layer_create
        transparent_layer(:s_lattice_layer).tap do |e|
          lattice_draw(e)
          inner_frame_draw(e)
          star_draw(e)
        end
      end

      # 外枠を含まない格子
      # line で stroke を使うと fill + stroke で二重に同じところを塗るっぽい
      # だから半透明にしても濃くなる
      # なので fill だけにする
      # しかし、そうすると今度は 2px 以上が描画できなくなるのでやっぱり stroke も入れておく
      def lattice_draw(layer)
        draw_context(layer) do |g|
          g.stroke_width(lattice_stroke_width) # 2px 以上の場合はこれがいる
          g.stroke(inner_frame_lattice_color)  # (↑のときの色)
          g.fill = inner_frame_lattice_color   # 線の中心線の色(1pxだけならこれだけあればいい)

          (1...lattice.w).each do |x|
            line_draw(g, V[x, 0], V[x, lattice.h])
          end
          (1...lattice.h).each do |y|
            line_draw(g, V[0, y], V[lattice.w, y])
          end
        end
      end

      # 格子の外枠
      # 盤から見れば内側
      # 基本透明で枠だけを描画する
      # 塗り潰したいときは board_layer_create の方で行うべき
      # inner_frame_stroke_width が 0 または nil で inner_frame_fill_color も nil ならスキップ
      def inner_frame_draw(layer)
        if inner_frame_stroke_width > 0 || params[:inner_frame_fill_color]
          draw_context(layer) do |g|
            g.stroke(inner_frame_stroke_color)
            g.stroke_width(inner_frame_stroke_width)
            g.fill = params[:inner_frame_fill_color] || "transparent"
            g.rectangle(*px(V[0, 0]), *px(V[lattice.w, lattice.h])) # QUESTION: 右下は -1, -1 するべきか？
          end
        end
      end

      def star_draw(layer)
        draw_context(layer) do |g|
          g.stroke("transparent")
          g.fill(star_fill_color)

          i = params[:star_step]
          (i...lattice.w).step(i) do |x|
            (i...lattice.h).step(i) do |y|
              v = V[x, y]
              g.circle(*px(v), *px(v + V.one * params[:star_size]))
            end
          end
        end
      end

      # 盤 padding を入れる場合 or 盤画像
      def board_layer_create
        layer = transparent_layer(:s_board_layer)
        case
        when params[:fg_file]
          if false
            # 座標を見ずに画面中央に表示する場合
            layer.composite!(texture_image, Magick::CenterGravity, 0, 0, Magick::OverCompositeOp)
          else
            # 自分で座標を指定すると1ドット左に寄っているように見えるので ceil で補正している
            # https://rmagick.github.io/image1.html#composite
            layer.composite!(texture_image, *px(outer_top_left).collect(&:ceil), Magick::OverCompositeOp)
          end
        else
          draw_context(layer) do |g|
            if params[:outer_frame_stroke_width].nonzero?
              g.stroke(params[:outer_frame_stroke_color])
              g.stroke_width(params[:outer_frame_stroke_width])
            end
            g.fill = params[:outer_frame_fill_color]
            g.roundrectangle(*px(outer_top_left), *px(outer_bottom_right), *round_radious) # stroke_width に応じてずれる心配なし
          end
        end

        if v = params[:cell_colors].presence
          colors = Array(v).cycle
          cell_walker do |v|
            color = colors.next
            if color
              draw_context(layer) do |g|
                g.fill = color
                # NOTE: 格子が1pxの場合に隙間ができるため minus_one しない方がよさそう
                if false
                  g.rectangle(*px(v), *minus_one(*px(v + V.one))) # 隙間ができる
                else
                  g.rectangle(*px(v), *px(v + V.one)) # 正確ではないが隙間ができない
                end
              end
            end
          end
        end

        with_shadow(layer)
      end

      # 盤テクスチャ
      #
      # 1. テクスチャと同じサイズの透明の画像を準備
      # 2. 透明画像で表示したい部分を塗り潰す (このとき角だけ透明になっている)
      # 3. その透明画像が金型なので元のテクスチャに押し当てる (CopyAlphaCompositeOp)
      # 4. 角が取れたテクスチャが出来上がる
      #
      def texture_image
        @texture_image ||= yield_self do
          image = Magick::Image.read(params[:fg_file].to_s).first
          image.resize_to_fill!(*ps(outer_rect))

          # 角を取る場合
          if outer_frame_radius.nonzero?
            mask = Magick::Image.new(image.columns, image.rows) { |e| e.background_color = "transparent" }
            Magick::Draw.new.tap do |gc|
              gc.stroke("none")
              gc.stroke_width(0)
              gc.fill("white") # 透明以外であれば何でもよい
              gc.roundrectangle(0, 0, mask.columns - 1, mask.rows - 1, *round_radious) # 見たい部分を塗る
              gc.draw(mask)
            end
            image.composite!(mask, 0, 0, Magick::CopyAlphaCompositeOp) # 角が取れる
          end

          image
        end
      end

      def inner_frame_lattice_color
        params[:inner_frame_lattice_color] || params[:piece_font_color]
      end

      def star_fill_color
        params[:star_fill_color] || inner_frame_lattice_color
      end

      def inner_frame_stroke_color
        params[:inner_frame_stroke_color] || params[:piece_font_color]
      end
    end
  end
end
