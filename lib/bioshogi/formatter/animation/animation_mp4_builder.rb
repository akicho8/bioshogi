# frozen-string-literal: true
#
# フレームレートを指定値に変換する。指定しない場合は入力ファイルの値を継承
# http://mobilehackerz.jp/archive/wiki/index.php?%BA%C7%BF%B7ffmpeg%A4%CE%A5%AA%A5%D7%A5%B7%A5%E7%A5%F3%A4%DE%A4%C8%A4%E1
# 小数で指定してはいけない
#
# FFMPEG でのフレームレート設定の違い
# https://nico-lab.net/setting_fps_with_ffmpeg/
# 入力オプションとしての -r
# 入力ファイルの前に指定する。総フレーム数はそのままに1秒あたりのフレームレートを指定するので、オリジナルよりフレームレートが少なければ動画時間が長く、多ければ動画時間が短くなる。
#
# ruby 0102_speed_compare.rb
# 7819.15000002482
# 9034.157999994932
# -rw------- 1 ikeda staff  60K  8 16 19:16 _output0.mp4
# -rw-r--r-- 1 ikeda staff 119K  8 16 19:16 _output1_1.mp4
# -rw-r--r-- 1 ikeda staff 135K  8 16 19:17 _output1_2.mp4
#
# ▼ビデオビットレート関連オプション
#
#   https://tech.ckme.co.jp/ffmpeg_h264.shtml
#   |-------------+--------+--------------------------------------------------------------------------------------------------------|
#   | オプション  | 初期値 | 意味                                                                                                   |
#   |-------------+--------+--------------------------------------------------------------------------------------------------------|
#   | -crf 23     | 23     | 品質固定モード。18..23 推奨。保存用なら18未満、モバイルなら24以上もあり。6減るとビットレートが倍になる |
#   | -b:v XXXk   | なし   | ビットレート一定モード。FullHDで25M。4kで100Mは欲しい                                                  |
#   | -preset xxx | medium | crf のとき使える。placebo になるほど遅いがファイルサイズが減る                                         |
#   | -tune       | なし   | preset のとき使える。stillimage はスライドショー用                                                     |
#   |-------------+--------+--------------------------------------------------------------------------------------------------------|
#
# ▼確認
#
#   info = Bioshogi::Parser.parse("position startpos moves 7g7f 8c8d 7i6h 3c3d 6h7g")
#   bin = info.to_animation_mp4(end_duration: 1, cover_text: "x", progress_callback: -> e { puts e.log })
#   Pathname("_output.mp4").write(bin)
#
module Bioshogi
  module Formatter
    module Animation
      class AnimationMp4Builder
        include Builder
        include AnimationBuilderTimeout
        include FfmpegSupport

        def self.default_params
          super.merge({
              # Audio関連
              :audio_enable        => true, # 音を結合するか？
              :fadeout_duration    => nil,  # ファイドアウト秒数。空なら end_pages * page_duration
              :main_volume         => 0.8,  # 音量

              # テーマ関連
              :audio_theme_key     => nil,  # テーマみたいなものでパラメータを一括設定するキー。audio_theme_none なら明示的にオーディオなしにするけど、nilなら何もしない
              :audio_part_a        => ASSETS_DIR.join("audios/headspin_long.m4a"),        # 序盤
              :audio_part_b        => ASSETS_DIR.join("audios/breakbeat_long_strip.m4a"), # 中盤移行
              :audio_part_a_volume => 1.0,  # DEPRECATION: 1.0 固定とする
              :audio_part_b_volume => 1.0,  # DEPRECATION: 1.0 固定とする
              :acrossfade_duration => 2.0,  # 0なら単純な連結

              # 埋め込み
              :metadata_title   => nil,
              :metadata_comment => nil,

              :video_crf           => 23,           # video 品質固定モード(基本こちらを指定する。初期値23で18..23推奨。24以上でモバイル向け)
              :video_bit_rate      => nil,          # video ビットレート一定モード(基本指定しない)
              :video_tune          => "stillimage", # video 最適化の種類 stillimage:動きの少ない動画用
              :audio_bit_rate      => nil,          # audio ビットレート。ffmpegの初期値 128k
            })
        end

        # attr_accessor :formatter
        # attr_accessor :params

        def initialize(formatter, params = {})
          @formatter = formatter
          @params = self.class.default_params.merge(params)
          if audio_theme_info
            @params.update(audio_theme_info.to_params)
          end
          # theme を上書きする用
          if v = params[:audio_theme_override_params]
            @params.update(v)
          end
        end

        # リファクタリングしたくなる気持ちを抑えよう(重要)
        def to_binary
          logger.tagged(self.class.name.demodulize) do
            in_work_directory do
              logger.tagged("video") do
                logger.info { "1. 動画準備" }

                logger.info { "生成に使うもの: #{factory_method_key}" }
                logger.info { "最後に追加するページ数(end_pages): #{end_pages}" }
                logger.info { "1手当たりの秒数(page_duration): #{page_duration}" }

                command_required! :ffmpeg
                ffmpeg_version_required!

                @xcontainer = @formatter.xcontainer_for_image
                @screen_image_renderer = ScreenImage.renderer(@xcontainer, params)

                if factory_method_key == "is_factory_method_rmagick"
                  @progress_cop = ProgressCop.new(1 + 1 + @formatter.mi.move_infos.size + 3 + 7, &params[:progress_callback])

                  begin
                    list = Magick::ImageList.new

                    if v = params[:cover_text].presence
                      @progress_cop.next_step("表紙描画")
                      tob("表紙描画") { list << CoverImage.renderer(text: v, **params.slice(:bottom_text, :width, :height)).render }
                    end

                    @progress_cop.next_step("初期配置")
                    list << @screen_image_renderer.next_build
                    @formatter.mi.move_infos.each.with_index do |e, i|
                      @progress_cop.next_step("(#{i}/#{@formatter.mi.move_infos.size}) #{e[:input]}")
                      @xcontainer.execute(e[:input])
                      list << @screen_image_renderer.next_build
                      logger.info { "move: #{i} / #{@formatter.mi.move_infos.size}" } if i.modulo(10).zero?
                    end
                    end_pages.times do |i|
                      @progress_cop.next_step("終了図 #{i}/#{end_pages}")
                      tob("終了図 #{i}/#{end_pages}") { list << @screen_image_renderer.last_rendered_image.copy }
                    end
                    @progress_cop.next_step("mp4 生成")
                    heavy_tob(:write) do
                      list.write("_output0.mp4") # staging ではここで例外も出さずに落ちることがある
                    end
                    logger.info { "write[end]: _output0.mp4" }
                    logger.info { `ls -alh _output0.mp4`.strip }
                    logger.info { "_output0.mp4: #{Media.duration('_output0.mp4')}" } if false
                    @page_count = list.count
                  ensure
                    list.each(&:destroy!) # 恐いので明示的に解放しとこう
                  end

                  logger.info { "合計ページ数: #{@page_count}" }

                  @progress_cop.next_step("YUV420変換")
                  logger.info { "1. YUV420化" }
                  strict_system %(ffmpeg -v warning -hide_banner -r #{fps_value} -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{video_crf_o} #{video_tune_o} #{video_bit_rate_o} #{ffmpeg_after_embed_options} -y _output1.mp4)
                end

                if factory_method_key == "is_factory_method_ffmpeg"
                  logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                  @progress_cop = ProgressCop.new(1 + 1 + @formatter.mi.move_infos.size + end_pages + 1 + 6, &params[:progress_callback])

                  logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                  if v = params[:cover_text].presence
                    logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                    @progress_cop.next_step("表紙描画")
                    logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                    tob("表紙描画") { CoverImage.renderer(text: v, **params.slice(:bottom_text, :width, :height)).render.write(sfg.next) }
                    logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                  end

                  logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                  @progress_cop.next_step("初期配置")
                  logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }
                  tob("初期配置") { @screen_image_renderer.next_build.write(sfg.next) }
                  logger.info { "[TRACE] #{__FILE__}:#{__LINE__}" }

                  @formatter.mi.move_infos.each.with_index do |e, i|
                    @progress_cop.next_step("(#{i}/#{@formatter.mi.move_infos.size}) #{e[:input]}")
                    @xcontainer.execute(e[:input])
                    logger.info("@xcontainer.execute OK")
                    tob("#{i}/#{@formatter.mi.move_infos.size}") { @screen_image_renderer.next_build.write(sfg.next) }
                    logger.info("@screen_image_renderer.next_build.write OK")
                    logger.info { "move: #{i} / #{@formatter.mi.move_infos.size}" } if i.modulo(10).zero?
                  end
                  end_pages.times do |i|
                    @progress_cop.next_step("終了図 #{i}/#{end_pages}")
                    tob("終了図 #{i}/#{end_pages}") { @screen_image_renderer.last_rendered_image.write(sfg.next) }
                  end

                  logger.info { sfg.inspect }
                  logger.info { "ソース画像確認\n#{sfg.shell_inspect}" }
                  @progress_cop.next_step("mp4 生成 #{sfg.index}p")
                  strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i #{sfg.name} -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{video_crf_o} #{video_tune_o} #{video_bit_rate_o} #{ffmpeg_after_embed_options} -y _output1.mp4)
                  logger.info { `ls -alh _output1.mp4`.strip }
                  @page_count = sfg.index
                end

                @screen_image_renderer.clear_all
              end

              if true
                @progress_cop.next_step("メタデータ埋め込み")
                title = params[:metadata_title].presence || "総手数#{@xcontainer.turn_info.display_turn}手"
                comment = params[:metadata_comment].presence || @xcontainer.to_history_sfen
                before_duration = Media.duration("_output1.mp4")
                strict_system %(ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="#{title}" -metadata comment="#{comment}" -codec copy -y _output2.mp4)
                after_duration = Media.duration("_output2.mp4")
                if before_duration != after_duration
                  # ffmpeg 3.4.8 では1ページ目が消える不具合あり
                  # metadata に関係なく ffmpeg -i _output1.mp4 -codec copy -y _output2.mp4 で1ページが飛ぶ
                  # 長さも1秒減る
                  raise FfmpegError, "-codec copy しただけで長さが変わっている: #{before_duration} --> #{after_duration}"
                end
              end

              if !primary_audio_file
                return Pathname("_output2.mp4").read
              end

              logger.tagged("audio") do
                logger.info { "2. BGM準備" }

                if @xcontainer.outbreak_turn
                  @switch_turn = @xcontainer.outbreak_turn + 1 # 取った手の位置が欲しいので「取る直前」+ 1
                  logger.info { "BGMが切り替わるページ(switch_turn): #{@switch_turn}" }
                end

                logger.info { "予測した全体の秒数(total_duration): #{total_duration}" }

                if @switch_turn && audio_part_a && audio_part_b
                  logger.info { "開戦前後で分ける" }
                  part1_t = @switch_turn * page_duration + acrossfade_duration # audio1 側を伸ばす
                  part2_t = (@page_count - @switch_turn) * page_duration # audio2 側の長さは同じ

                  @progress_cop.next_step("序盤 BGM時間・音量調整")
                  # strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -t #{part1} -af volume=#{params[:audio_part_a_volume]} -y _part1.m4a)
                  strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -vn -t #{part1_t} -af volume=#{params[:audio_part_a_volume]} -y _part1.m4a)
                  logger.info { "_part1.m4a: #{Media.duration('_part1.m4a')}" }

                  @progress_cop.next_step("終盤 BGM時間・音量調整")
                  strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_b} -vn -t #{part2_t} -af volume=#{params[:audio_part_b_volume]} -y _part2.m4a)
                  logger.info { "_part2.m4a: #{Media.duration('_part2.m4a')}" }

                  @progress_cop.next_step("クロスフェイド連結")
                  strict_system %(ffmpeg -v warning -i _part1.m4a -i _part2.m4a -filter_complex #{cross_fade_option} _concat.m4a)

                  @progress_cop.next_step("フェイドアウト処理")
                  strict_system %(ffmpeg -v warning -i _concat.m4a #{audio_filters(fadeout_value)} #{audio_bit_rate_o} _same_length1.m4a)
                else
                  # 開戦しない場合は A, B パートの存在する方の曲を先頭から入れる
                  [
                    [audio_part_a, params[:audio_part_a_volume]],
                    [audio_part_b, params[:audio_part_b_volume]],
                  ].each do |audio_part_x, volume|
                    if audio_part_x
                      logger.info { "開戦前のみ" }
                      logger.info { "audio_part_x: #{audio_part_x}" }
                      @progress_cop.next_step("フェイドアウトと音量調整")
                      af = audio_filters("volume=#{volume}", fadeout_value)
                      strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_x} -vn -t #{total_duration} #{af} #{audio_bit_rate_o} -y _same_length1.m4a)
                      logger.info { "#{audio_part_x.basename}: #{Media.duration(audio_part_x)}" }
                      break
                    end
                  end
                end

                logger.info { "fadeout_duration: #{fadeout_duration}" }

                @progress_cop.next_step("全体の音量調整")
                strict_system %(ffmpeg -v warning -i _same_length1.m4a -af volume=#{main_volume} -y _same_length2.m4a)
                logger.info { "_same_length2.m4a: #{Media.duration('_same_length2.m4a')}" }
              end

              logger.info { "3. 結合" }
              @progress_cop.next_step("BGM結合")
              strict_system %(ffmpeg -v warning -i _output2.mp4 -i _same_length2.m4a -c copy -y _output3.mp4)
              Pathname("_output3.mp4").read
            end
          end
        end

        private

        ################################################################################ Video

        def video_crf_o
          if v = params[:video_crf].presence
            ["-crf", v].shelljoin
          end
        end

        def video_bit_rate_o
          if v = params[:video_bit_rate].presence
            ["-b:v", v].shelljoin
          end
        end

        def video_tune_o
          if v = params[:video_tune].presence
            ["-tune", v].shelljoin
          end
        end

        ################################################################################ Audio

        def fadeout_duration
          (params[:fadeout_duration].presence || (page_duration * end_pages)).to_f
        end

        def audio_part_a
          if v = params[:audio_part_a]
            Pathname(v).expand_path
          end
        end

        def audio_part_b
          if v = params[:audio_part_b]
            Pathname(v).expand_path
          end
        end

        def primary_audio_file
          audio_part_a || audio_part_b
        end

        def acrossfade_duration
          params[:acrossfade_duration].to_f
        end

        def main_volume
          params[:main_volume].to_f
        end

        def total_duration
          @page_count * page_duration
        end

        def fadeout_value
          if fadeout_duration > 0
            start_time = total_duration - fadeout_duration
            "afade=t=out:start_time=#{start_time}:duration=#{fadeout_duration}"
          end
        end

        def audio_filters(*args)
          args = args.compact
          if args.present?
            "-af " + args.join(",")
          end
        end

        # 長さ d=0 にしてもクロスフェイド効果があるっぽいので 0 なら単に結合する
        def cross_fade_option
          if acrossfade_duration > 0
            %("acrossfade=duration=#{acrossfade_duration}")
          else
            %("concat=n=2:v=0:a=1")
          end
        end

        def audio_bit_rate_o
          if v = params[:audio_bit_rate].presence
            ["-b:a", v].shelljoin
          end
        end

        def audio_theme_info
          AudioThemeInfo.fetch_if(params[:audio_theme_key])
        end

        # def to_h
        #   {
        #     "最後に追加したページ数(end_pages)" => end_pages,
        #     "合計ページ数(page_count)"          => @page_count,
        #     "1ページ当たりの秒数(page_duration)"  => page_duration,
        #     "予測した全体の秒数(total_duration)"   => total_duration,
        #     "BGMが切り替わるページ(switch_turn)" => @switch_turn,
        #   }
        # end
      end
    end
  end
end
