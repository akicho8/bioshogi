module Bioshogi
  class AnimationGifFormatter
    include FormatterUtils

    cattr_accessor :default_params do
      {
        :end_frames         => 0,                  # 終了図だけ指定フレーム数停止
        :one_frame_duration => 1.0,                # 1手N秒
        :loop_key           => "is_loop_infinite", # ループモード

        :tmpdir_remove      => true, # 作業ディレクトリを最後に削除するか？ (デバッグ時にはfalseにする)
        :mp4_factory_key    => "ffmpeg", # rmagick or ffmpeg
      }
    end

    attr_accessor :parser
    attr_accessor :params

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
    end

    def to_binary
      logger.tagged("mp4_formatter") do
        in_work_directory do
          @mediator = parser.mediator_for_image
          @image_formatter = ImageFormatter.new(@mediator, params)
          @list = Magick::ImageList.new
          @image_formatter.render
          @list.concat([@image_formatter.canvas])
          parser.move_infos.each.with_index do |e, i|
            @mediator.execute(e[:input])
            # puts @mediator
            @image_formatter.render
            # @image_formatter.canvas.write("_#{i}.gif")
            @list.concat([@image_formatter.canvas]) # canvas は Magick::Image のインスタンス
          end
          @list.concat([@image_formatter.canvas] * params[:end_frames])
          @list.delay = @list.ticks_per_second * one_frame_duration

          # @list.each.with_index do |e, i|
          #   e.write("_#{i}.gif")
          # end

          logger.info { "one_frame_duration: #{one_frame_duration}" }
          logger.info { "ticks_per_second: #{@list.ticks_per_second}" }
          logger.info { "delay: #{@list.delay}" }

          # if params[:optimize_layer]

          # 46s 5.5M optimize_layers なし
          # 43s 544K optimize_layers あり
          @list = @list.optimize_layers(Magick::OptimizeLayer) # 各ページを最小枠にする (重要)
          # end
          @list.iterations = iterations_number  # 繰り返し回数

          if mp4_factory_key == "rmagick"
            logger.info { "write[begin]: _output1.#{ext_name}" }
            @list.write("_output1.#{ext_name}")
            logger.info { "write[end]: _output1.#{ext_name}" }
          end

          if mp4_factory_key == "ffmpeg"
            raise
          end

          @list.destroy!
          File.binread("_output1.#{ext_name}")
        end
      end
    end

    private

    def ext_name
      "gif"
    end

    # 繰り返し回数
    #
    #  0: 無限ループ
    #  1: 1回
    #  2: 2回
    #
    # exiftool では "Animation Iterations" の項目でこの値がわかるが1ずれている
    # exiftool では「繰り返す回数」つまり「戻る回数」なので1なら戻らないので0で、なぜか0は表示されない
    # 0なら無限と表示され、2なら1回(戻る)と表示される
    #
    def iterations_number
      if params[:loop_key] == "is_loop_infinite"
        0
      else
        1
      end
    end

    def one_frame_duration
      params[:one_frame_duration]
    end
  end
end
