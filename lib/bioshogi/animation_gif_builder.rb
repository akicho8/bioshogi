module Bioshogi
  class AnimationGifBuilder
    include Builder
    include AnimationBuilderTimeout
    include FfmpegSupport

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
          logger.info { "生成に使うもの: #{factory_method_key}" }
          logger.info { "最後に追加するフレーム数(end_pages): #{end_pages}" }
          logger.info { "1手当たりの秒数(page_duration): #{page_duration}" }

          @xcontainer = @parser.xcontainer_for_image
          @image_renderer = ImageRenderer.new(@xcontainer, params)

          if factory_method_key == "is_factory_method_rmagick"
            @progress_cop = ProgressCop.new(1 + 1 + @parser.mi.move_infos.size + end_pages + 1 + 1, &params[:progress_callback])

            begin
              list = Magick::ImageList.new

              if v = params[:cover_text].presence
                @progress_cop.next_step("表紙描画")
                tob("表紙描画") { list << CoverRenderer.new(text: v, **params.slice(:bottom_text, :width, :height)).render }
              end

              @progress_cop.next_step("初期配置")
              tob("初期配置") { list << @image_renderer.next_build }

              @parser.mi.move_infos.each.with_index do |e, i|
                @progress_cop.next_step("(#{i}/#{@parser.mi.move_infos.size}) #{e[:input]}")
                @xcontainer.execute(e[:input])
                tob("#{i}/#{@parser.mi.move_infos.size}") { list << @image_renderer.next_build }
                logger.info { "move: #{i} / #{@parser.mi.move_infos.size}" } if i.modulo(10).zero?
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

          if factory_method_key == "is_factory_method_ffmpeg"
            command_required! :ffmpeg

            @progress_cop = ProgressCop.new(1 + 1 + @parser.mi.move_infos.size + end_pages + 1, &params[:progress_callback])

            if v = params[:cover_text].presence
              @progress_cop.next_step("表紙描画")
              tob("表紙描画") { CoverRenderer.new(text: v, **params.slice(:bottom_text, :width, :height)).render.write(sfg.next) }
            end

            @progress_cop.next_step("初期配置")
            tob("初期配置") { @image_renderer.next_build.write(sfg.next) }

            @parser.mi.move_infos.each.with_index do |e, i|
              @progress_cop.next_step("(#{i}/#{@parser.mi.move_infos.size}) #{e[:input]}")
              @xcontainer.execute(e[:input])
              tob("#{i}/#{@parser.mi.move_infos.size}") { @image_renderer.next_build.write(sfg.next) }
              logger.info { "move: #{i} / #{@parser.mi.move_infos.size}" } if i.modulo(10).zero?
            end

            end_pages.times do |i|
              @progress_cop.next_step("終了図 #{i}/#{end_pages}")
              tob("終了図 #{i}/#{end_pages}") { @image_renderer.last_rendered_image.write(sfg.next) }
            end

            @progress_cop.next_step("#{ext_name} 生成 #{sfg.index}p")
            logger.info { sfg.inspect }
            logger.info { "ソース画像確認\n#{sfg.shell_inspect}" }
            strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i #{sfg.name} #{ffmpeg_option_fine_tune_for_each_file_type} #{ffmpeg_after_embed_options} -y _output1.#{ext_name})
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

    # 「1枚目に白黒のタイトル画像があり、次に盤の画像が並ぶ場合、盤が白黒になってしまうのを防ぐ」ために
    # 追加したオプションだったが、元凶は1枚目がグレースケールだったのでそれを PNG24: で保存すればグレー化問題は解決した
    # だからこのオプションを外したら GIF が超汚ない
    # グレー化問題にかかわらずこのオプションは付けておいた方がよさそうだ
    #
    # 具体的に何がなんだかわかってない
    # とりあえず下のサイトから拝借してサイズやフレーム数を取った
    # また stats_mode を single 以外にすると1枚目の画像がスキップされてしまうので注意
    # これは ffmpeg のバグだろうか。これもよくわからない
    #
    # ffmpegでとにかく綺麗なGIFを作りたい
    # https://qiita.com/yusuga/items/ba7b5c2cac3f2928f040
    #
    # FFMPEG で 256色を最適化する PALETTEGEN, PALETTEUSE
    # https://nico-lab.net/optimized_256_colors_with_ffmpeg/
    def ffmpeg_option_fine_tune_for_each_file_type
      %(-filter_complex "[0:v] split [a][b];[a] palettegen=stats_mode=single:reserve_transparent=0 [p];[b][p] paletteuse=new=1")
    end
  end
end
