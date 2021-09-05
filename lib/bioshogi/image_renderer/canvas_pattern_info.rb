module Bioshogi
  class ImageRenderer
    class CanvasPatternInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :pattern_checker_light, command: :checker1, default_params: { base_color: "#fff", accent_color: "rgba(  0,  0,  0, 0.04)", }, },
        { key: :pattern_checker_dark,  command: :checker1, default_params: { base_color: "#333", accent_color: "rgba(255,255,255, 0.04)", }, },
      ]

      def execute(params = {})
        send(command, {**default_params, **params})
      end

      def display(params = {})
        file = Pathname("#{Dir.tmpdir}/_#{SecureRandom.hex}.png")
        execute(params).write(file)
        `open #{file}`
      end

      private

      # FIXME: 激重なので生成したものをディスクキャッシュする
      def checker1(rect: Rect[800, 600], base_color: "#fff", accent_color: "rgba(0,0,0,0.03)", w: 16, h: 16)
        require "rmagick"
        Magick::Image.new(*rect) { |e| e.background_color = base_color }.tap do |layer|
          (layer.rows.fdiv(h)).ceil.times do |y|
            (layer.columns.fdiv(w)).ceil.times do |x|
              if (x + y).even?
                g = Magick::Draw.new
                g.fill(accent_color)
                g.rectangle(x * w, y * h, x * w + w - 1, y * h + h - 1)
                g.draw(layer)
              end
            end
          end
        end
      end
    end
  end
end
