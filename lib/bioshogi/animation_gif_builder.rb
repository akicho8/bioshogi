module Bioshogi
  class AnimationGifBuilder
    include AnimationBuilderHelper

    def self.default_params
      super.merge({
          :loop_key => "is_loop_infinite", # ループモード
        })
    end

    # attr_accessor :parser
    # attr_accessor :params

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_binary
      logger.tagged(self.class.name.demodulize) do
        in_work_directory do
          logger.info { "生成に使うもの: #{media_factory_key}" }
          logger.info { "最後に追加するフレーム数(end_frames): #{end_frames}" }
          logger.info { "1手当たりの秒数(one_frame_duration_sec): #{one_frame_duration_sec}" }

          @mediator = @parser.mediator_for_image
          @image_renderer = ImageRenderer.new(@mediator, params)

          if media_factory_key == "rmagick"
            begin
              list = Magick::ImageList.new
              list.concat([@image_renderer.next_build])
              @parser.move_infos.each.with_index do |e, i|
                @mediator.execute(e[:input])
                list.concat([@image_renderer.next_build])
                logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
              end
              list.concat([@image_renderer.last_rendered_image] * end_frames)
              list.delay = list.ticks_per_second * one_frame_duration_sec

              logger.info { "ticks_per_second: #{list.ticks_per_second}" }
              logger.info { "delay: #{list.delay}" }

              # 46s 5.5M optimize_layers なし
              # 43s 544K optimize_layers あり
              may_die(:optimize_layers) do
                list = list.optimize_layers(Magick::OptimizeLayer) # 各ページを最小枠にする (重要) ステージングではここで落ちる
              end
              list.iterations = iterations_number  # 繰り返し回数
              may_die(:write) do
                list.write("_output1.#{ext_name}")
              end
            ensure
              list.destroy!
            end
          end

          if media_factory_key == "ffmpeg"
            @frame_count = 0
            @image_renderer.next_build.write("_input%04d.png" % @frame_count)
            @frame_count += 1
            @parser.move_infos.each.with_index do |e, i|
              @mediator.execute(e[:input])
              @image_renderer.next_build.write("_input%04d.png" % @frame_count)
              @frame_count += 1
              logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
            end
            end_frames.times do
              @image_renderer.last_rendered_image.write("_input%04d.png" % @frame_count)
              @frame_count += 1
            end
            logger.info { "合計フレーム数(frame_count): #{@frame_count}" }
            logger.info { "ソース画像生成数: " + `ls -alh _input*.png | wc -l`.strip }
            strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i _input%04d.png #{ffmpeg_after_embed_options} -y _output1.#{ext_name})
            logger.info { `ls -alh _output1.#{ext_name}`.strip }
          end

          @image_renderer.clear_all

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
