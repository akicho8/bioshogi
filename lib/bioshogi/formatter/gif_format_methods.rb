module Bioshogi
  module Formatter
    concern :GifFormatMethods do
      def to_gif(options = {})
        options = {
          :delay_per_one => 1.0,   # 1枚をN秒で表示する
          :format        => "gif", #
          :loop          => false, # ループするか？
        }.merge(options)

        mediator = Mediator.new         # MediatorFast にする
        mediator.params.update({
            :skill_monitor_enable           => false,
            :skill_monitor_technique_enable => false,
            :candidate_enable               => false,
            :validate_enable                => false,
          })
        mediator_board_setup(mediator)
        image_formatter = ImageFormatter.new(mediator, viewpoint: "black")
        # puts mediator

        list = Magick::ImageList.new
        # list.ticks_per_second           # =>
        # list.delay = list.ticks_per_second
        # list.start_loop               # =>
        image_formatter.render
        list.concat([image_formatter.canvas])
        move_infos.each.with_index(1) do |e, i|
          mediator.execute(e[:input])
          image_formatter.render
          list.concat([image_formatter.canvas]) # canvas は Magick::Image のインスタンス
          # puts image_formatter.write_to_tempfile
          # image_formatter.canvas.write("#{i}.gif")
        end
        list.ticks_per_second           # => 100
        list.delay = list.ticks_per_second * options[:delay_per_one]

        list = list.coalesce            # 意味を調べる
        list = list.optimize_layers(Magick::OptimizeLayer)

        list.format = options[:format]
        list.iterations = gif_iterations(options)  # 繰り返し回数
        # list.start_loop = false
        # list.scene = 1
        list.to_blob

        # list.to_blob[0..3]              # => "GIF8"
        # list.write("out.gif")
        # list.each.with_index do |e, i|
        #   e.write("#{i}.png")
        # end
        # puts list.inspect # => nil

        # puts mediator
        # >> [0.png GIF 1200x630 1200x630+0+0 PseudoClass 33c 16-bit 25kb,
        # >> 1.png  68x135 1200x630+433+348 PseudoClass 33c 16-bit 1kb,
        # >> 2.png  42x109 1200x630+377+159 PseudoClass 34c 16-bit 1kb,
        # >> 3.png  42x109 1200x630+782+363 PseudoClass 34c 16-bit 1kb]
        # >> scene=0
      end

      private

      # 繰り返し回数
      #
      #  0: 無限ループ
      #  1: 1回
      #  2: 2回
      #
      # exiftool では "Animation Iterations" の項目でわかるが1ずれている
      # 表示される値は繰り返し回数なので1なら表示されず2回ループなら1と表示される
      #
      def gif_iterations(options)
        if options[:loop]
          0
        else
          1
        end
      end
    end
  end
end
