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
      logger.tagged("animation_gif_formatter") do
        in_work_directory do
          logger.info { "生成に使うもの: #{mp4_factory_key}" }
          logger.info { "最後に追加するフレーム数(end_frames): #{end_frames}" }
          logger.info { "1手当たりの秒数(one_frame_duration): #{one_frame_duration}" }

          @mediator = parser.mediator_for_image
          @image_formatter = ImageFormatter.new(@mediator, params)

          if mp4_factory_key == "rmagick"
            begin
              list = Magick::ImageList.new
              @image_formatter.render
              list.concat([@image_formatter.canvas])
              parser.move_infos.each.with_index do |e, i|
                @mediator.execute(e[:input])
                @image_formatter.render
                list.concat([@image_formatter.canvas]) # canvas は Magick::Image のインスタンス
                logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
              end
              list.concat([@image_formatter.canvas] * end_frames)
              list.delay = list.ticks_per_second * one_frame_duration

              logger.info { "ticks_per_second: #{list.ticks_per_second}" }
              logger.info { "delay: #{list.delay}" }

              # 46s 5.5M optimize_layers なし
              # 43s 544K optimize_layers あり
              logger.info { "optimize_layers[begin]" }
              list = list.optimize_layers(Magick::OptimizeLayer) # 各ページを最小枠にする (重要) ステージングではここで落ちる
              logger.info { "optimize_layers[end]" }

              list.iterations = iterations_number  # 繰り返し回数

              logger.info { "write[begin]: _output1.#{ext_name}" }
              list.write("_output1.#{ext_name}")
              logger.info { "write[end]: _output1.#{ext_name}" }
            ensure
              list.destroy!
            end
          end

          if mp4_factory_key == "ffmpeg"
            @frame_count = 0
            @image_formatter.render
            @image_formatter.canvas.write("_input%03d.png" % @frame_count)
            @frame_count += 1
            @parser.move_infos.each.with_index do |e, i|
              @mediator.execute(e[:input])
              @image_formatter.render
              @image_formatter.canvas.write("_input%03d.png" % @frame_count)
              @frame_count += 1
              logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
            end
            end_frames.times do
              @image_formatter.canvas.write("_input%03d.png" % @frame_count)
              @frame_count += 1
            end
            logger.info { "合計フレーム数(frame_count): #{@frame_count}" }
            logger.info { "ソース画像生成数: " + `ls -alh _input*.png | wc -l`.strip }

            logger.info { "write[begin]: _output1.#{ext_name}" }
            # strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i _input%03d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{ffmpeg_after_embed_options} -y _output1.gif)
            # strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i _input%03d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{ffmpeg_after_embed_options} -y _output1.gif)
            strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i _input%03d.png -y _output1.#{ext_name})
            logger.info { "write[end]: _output1.#{ext_name}" }
            logger.info { `ls -alh _output1.#{ext_name}`.strip }
          end

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
  end
end
