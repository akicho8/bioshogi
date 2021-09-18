module Bioshogi
  class AnimationGifBuilder
    include AnimationBuilderTimeout
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
          logger.info { "最後に追加するフレーム数(end_pages): #{end_pages}" }
          logger.info { "1手当たりの秒数(page_duration): #{page_duration}" }

          @mediator = @parser.mediator_for_image
          @image_renderer = ImageRenderer.new(@mediator, params)

          if media_factory_key == "rmagick"
            @progress_cop = ProgressCop.new(1 + 1 + @parser.move_infos.size + 3, &params[:progress_callback])

            begin
              list = Magick::ImageList.new

              if v = params[:cover_text].presence
                @progress_cop.next_step("表紙描画")
                tob("表紙描画") { list << CoverRenderer.new(text: v, **params.slice(:width, :height)).render }
              end

              @progress_cop.next_step("初期配置")
              tob("初期配置") { list << @image_renderer.next_build }

              @parser.move_infos.each.with_index do |e, i|
                @progress_cop.next_step("(#{i}/#{@parser.move_infos.size}) #{e[:input]}")
                @mediator.execute(e[:input])
                tob("#{i}/#{@parser.move_infos.size}") { list << @image_renderer.next_build }
                logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
              end

              end_pages.times do |i|
                @progress_cop.next_step("終了図 #{i}/#{end_pages}")
                tob("終了図 #{i}/#{end_pages}") { list << @image_renderer.last_rendered_image.copy }
              end

              list.delay = list.ticks_per_second * page_duration

              logger.info { "ticks_per_second: #{list.ticks_per_second}" }
              logger.info { "delay: #{list.delay}" }

              # 46s 5.5M optimize_layers なし
              # 43s 544K optimize_layers あり
              @progress_cop.next_step("最適化")
              heavy_tob(:optimize_layers) do
                list = list.optimize_layers(Magick::OptimizeLayer) # 各ページを最小枠にする (重要) ステージングではここで落ちる
              end

              list.iterations = iterations_number  # 繰り返し回数

              @progress_cop.next_step("#{ext_name} 生成")
              heavy_tob(:write) do
                list.write("_output1.#{ext_name}")
              end
            ensure
              list.destroy!
            end
          end

          if media_factory_key == "ffmpeg"
            command_required! :ffmpeg

            @progress_cop = ProgressCop.new(1 + 1 + @parser.move_infos.size + 1, &params[:progress_callback])

            @page_count = 0

            if v = params[:cover_text].presence
              @progress_cop.next_step("表紙描画")
              tob("表紙描画") { CoverRenderer.new(text: v, **params.slice(:width, :height)).render.write(file_next) }
            end

            @progress_cop.next_step("初期配置")
            tob("初期配置") { @image_renderer.next_build.write(file_next) }

            @parser.move_infos.each.with_index do |e, i|
              @progress_cop.next_step("(#{i}/#{@parser.move_infos.size}) #{e[:input]}")
              @mediator.execute(e[:input])
              tob("#{i}/#{@parser.move_infos.size}") { @image_renderer.next_build.write(file_next) }
              logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
            end

            end_pages.times do |i|
              @progress_cop.next_step("終了図 #{i}/#{end_pages}")
              tob("終了図 #{i}/#{end_pages}") { @image_renderer.last_rendered_image.write(file_next) }
            end

            @progress_cop.next_step("#{ext_name} 生成")
            logger.info { "合計フレーム数(page_count): #{@page_count}" }
            logger.info { "ソース画像生成数: " + `ls -alh _input*.png | wc -l`.strip }
            strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i #{number_file} #{ffmpeg_after_embed_options} -y _output1.#{ext_name})
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
