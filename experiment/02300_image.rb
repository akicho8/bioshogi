require "./example_helper"
require "matrix"

module Bioshogi
  class ImageFormatter
    cattr_accessor :default_params do
      {
        image_w: 1600,
        image_h: 630,
        ookisa: 0.95,           # 縦幅に対する盤の縦の割合
        pointsize_rate: 0.5,    # セルの大きさに対する文字の大きさの割合
      }
    end

    attr_accessor :parser
    attr_accessor :params

    def initialize(parser, **params)
      require "rmagick"

      @parser = parser
      @params = default_params.merge(params)
      @rendered = false
    end

    def render
      if @rendered
        return
      end
      masumekakuyo
      komaokuyo
      @rendered = true
    end

    def display
      canvas.write("_output.png")
      `open _output.png`
    end

    def canvas
      @canvas ||= -> {
        canvas = Magick::ImageList.new
        canvas.new_image(*image_rect) do
          self.background_color = "white"
        end
      }.call
    end

    private

    def image_rect
      Rect[params[:image_w], params[:image_h]]
    end

    def masume
      Rect[Bioshogi::Dimension::Xplace.dimension, Bioshogi::Dimension::Yplace.dimension]
    end

    def cell_size
      (params[:image_h] * params[:ookisa]) / masume.h
    end

    def cell_size_rect
      @cell_size_rect ||= Rect[cell_size, cell_size]
    end

    def center
      Vec[canvas.columns / 2, canvas.rows / 2]
    end

    def hidariue
      @hidariue ||= center - masume * cell_size / 2
    end

    def real_pos(v)
      hidariue + v * cell_size
    end

    def line(v1, v2)
      masume_gc.line(*real_pos(v1), *real_pos(v2))
    end

    def masume_gc
      @masume_gc ||= -> {
        gc = Magick::Draw.new
        gc.stroke("black")
      }.call
    end

    def masumekakuyo
      masume.w.next.times do |x|
        v1 = Vec[x, 0]
        v2 = v1 + Vec[0, masume.h]
        line(v1, v2)
      end
      masume.h.next.times do |y|
        v1 = Vec[0, y]
        v2 = v1 + Vec[masume.w, 0]
        line(v1, v2)
      end
      masume_gc.draw(canvas)
    end

    def komaokuyo
      masume.h.times do |y|
        masume.w.times do |x|
          v = Vec[x, y]
          if soldier = parser.mediator.board.lookup(v)
            gc = Magick::Draw.new
            gc.rotation = soldier.location.angle
            gc.pointsize = my_pointsize
            gc.font = "Meiryo"
            gc.stroke = "transparent"
            gc.fill = "black"
            gc.gravity = Magick::CenterGravity
            gc.annotate(canvas, *cell_size_rect, *real_pos(v), soldier.any_name)
          end
        end
      end
    end

    def my_pointsize
      cell_size * params[:pointsize_rate]
    end

    def koma(v)
      # rows = Bioshogi::Dimension::Yplace.dimension.times.collect do |y|
      #   tds = Bioshogi::Dimension::Xplace.dimension.times.collect do |x|
      #     tag_class = []
      #     cell = ""
      #     if soldier = board.surface[[x, y]]
      #       tag_class << soldier.player.location.key
      #       cell = soldier.any_name
      #     end
      #     if hand_log = hand_logs.last
      #       if hand_log.place_to == Bioshogi::Place[[x, y]]
      #         tag_class << "last_place"
      #       end
      #       if hand_log.place_from == Bioshogi::Place[[x, y]]
      #         tag_class << "last_place2"
      #       end
      #     end
      #     "<td class=\"#{tag_class.join(" ")}\">#{cell}</td>"
      #   end
      #   "<tr>#{tds.join("\n")}</tr>"
      # end
      # "<table class=\"board #{type}\">\n#{rows.join("\n")}\n</table>"
    end

    class Vec < Vector
      def x
        self[0]
      end

      def y
        self[1]
      end
    end

    class Rect < Vector
      def w
        self[0]
      end

      def h
        self[1]
      end
    end
  end
end

if $0 == __FILE__
  parser = Bioshogi::Parser.parse("▲68銀")
  object = Bioshogi::ImageFormatter.new(parser)
  object.render
  object.display
end
