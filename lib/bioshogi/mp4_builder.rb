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

# ruby 0102_speed_compare.rb
# 7819.15000002482
# 9034.157999994932
# -rw------- 1 ikeda staff  60K  8 16 19:16 _output0.mp4
# -rw-r--r-- 1 ikeda staff 119K  8 16 19:16 _output1_1.mp4
# -rw-r--r-- 1 ikeda staff 135K  8 16 19:17 _output1_2.mp4

module Bioshogi
  class Mp4Builder
    include AnimationBuilderCore
    include AnimationBuilderHelper

    def self.default_params
      super.merge({
          # Audio関連
          :audio_enable        => true, # 音を結合するか？
          :fadeout_duration    => nil,  # ファイドアウト秒数。空なら end_frames * one_frame_duration_sec
          # :main_volume         => 1.0,  # 音量

          # テーマ関連
          :audio_theme_key     => nil,  # テーマみたいなものでパラメータを一括設定するキー。audio_theme_none なら明示的にオーディオなしにするけど、nilなら何もしない
          :audio_part_a        => "#{__dir__}/assets/audios/headspin_long.m4a",        # 序盤
          :audio_part_b        => "#{__dir__}/assets/audios/breakbeat_long_strip.m4a", # 中盤移行
          :audio_part_a_volume => 1.0,
          :audio_part_b_volume => 1.0,
          :acrossfade_duration => 2.0,  # 0なら単純な連結

          :video_bit_rate      => nil,  # video ビットレート
          :audio_bit_rate      => nil,  # audio ビットレート

          # 埋め込み
          :metadata_title   => nil,
          :metadata_comment => nil,
        })
    end

    # attr_accessor :parser
    # attr_accessor :params

    def initialize(parser, params = {})
      @parser = parser
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

            logger.info { "生成に使うもの: #{media_factory_key}" }
            logger.info { "最後に追加するフレーム数(end_frames): #{end_frames}" }
            logger.info { "1手当たりの秒数(one_frame_duration_sec): #{one_frame_duration_sec}" }

            command_required! :ffmpeg

            @mediator = @parser.mediator_for_image
            @image_renderer = ImageRenderer.new(@mediator, params)

            if media_factory_key == "rmagick"
              @progress_cop = ProgressCop.new(1 + 1 + @parser.move_infos.size + 3 + 6, &params[:progress_callback])

              begin
                list = Magick::ImageList.new

                if v = params[:cover_text].presence
                  @progress_cop.next_step("タイトル")
                  list << CoverRenderer.new(text: v, **params.slice(:width, :height)).render
                end

                @progress_cop.next_step("初期配置")
                list.concat([@image_renderer.next_build])
                @parser.move_infos.each.with_index do |e, i|
                  @progress_cop.next_step("#{i.next}: #{e[:input]}")
                  @mediator.execute(e[:input])
                  list.concat([@image_renderer.next_build]) # canvas は Magick::Image のインスタンス
                  logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
                end
                @progress_cop.next_step("終了図")
                list.concat([@image_renderer.last_rendered_image] * end_frames)
                @progress_cop.next_step("mp4 生成")
                may_die(:write) do
                  list.write("_output0.mp4") # staging ではここで例外も出さずに落ちることがある
                end
                logger.info { "write[end]: _output0.mp4" }
                logger.info { `ls -alh _output0.mp4`.strip }
                logger.info { "_output0.mp4: #{Media.duration('_output0.mp4')}" } if false
                @frame_count = list.count
              ensure
                list.destroy!       # 恐いので明示的に解放しとこう
              end

              logger.info { "合計フレーム数(frame_count): #{@frame_count}" }

              @progress_cop.next_step("YUV420変換")
              logger.info { "1. YUV420化" }
              strict_system %(ffmpeg -v warning -hide_banner -r #{fps_value} -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{video_bit_rate_o} #{ffmpeg_after_embed_options} -y _output1.mp4)
            end

            if media_factory_key == "ffmpeg"
              @progress_cop = ProgressCop.new(1 + 1 + @parser.move_infos.size + end_frames + 1 + 6, &params[:progress_callback])

              @frame_count = 0

              if v = params[:cover_text].presence
                @progress_cop.next_step("タイトル")
                CoverRenderer.new(text: v, **params.slice(:width, :height)).render.write(number_file % @frame_count)
                @frame_count += 1
              end

              @progress_cop.next_step("初期配置")
              @image_renderer.next_build.write(number_file % @frame_count)
              @frame_count += 1

              @parser.move_infos.each.with_index do |e, i|
                @progress_cop.next_step("#{i.next}: #{e[:input]}")
                @mediator.execute(e[:input])
                logger.info("@mediator.execute OK")
                @image_renderer.next_build.write(number_file % @frame_count)
                logger.info("@image_renderer.next_build.write OK")
                @frame_count += 1
                logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
              end
              end_frames.times do
                @progress_cop.next_step("終了図 #{@frame_count}")
                @image_renderer.last_rendered_image.write(number_file % @frame_count)
                @frame_count += 1
              end

              logger.info { "合計フレーム数(frame_count): #{@frame_count}" }
              logger.info { "ソース画像生成数: " + `ls -alh _input*.png | wc -l`.strip }
              @progress_cop.next_step("mp4 生成")
              strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i #{number_file} -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{video_bit_rate_o} #{ffmpeg_after_embed_options} -y _output1.mp4)
              logger.info { `ls -alh _output1.mp4`.strip }
            end

            @image_renderer.clear_all
          end

          if true
            @progress_cop.next_step("メタデータ埋め込み")
            title = params[:metadata_title].presence || "#{@mediator.turn_info.display_turn}手目までの棋譜"
            comment = params[:metadata_comment].presence || @mediator.to_sfen
            strict_system %(ffmpeg -v warning -hide_banner -i _output1.mp4 -metadata title="#{title}" -metadata comment="#{comment}" -codec copy -y _output2.mp4)
          end

          if !primary_audio_file
            return Pathname("_output2.mp4").read
          end

          logger.tagged("audio") do
            logger.info { "2. BGM準備" }

            if @mediator.outbreak_turn
              @switch_turn = @mediator.outbreak_turn + 1 # 取った手の位置が欲しいので「取る直前」+ 1
              logger.info { "BGMが切り替わるフレーム(switch_turn): #{@switch_turn}" }
            end

            logger.info { "予測した全体の秒数(total_duration): #{total_duration}" }

            if @switch_turn && audio_part_a && audio_part_b
              logger.info { "開戦前後で分ける" }
              part1_t = @switch_turn * one_frame_duration_sec + acrossfade_duration # audio1 側を伸ばす
              part2_t = (@frame_count - @switch_turn) * one_frame_duration_sec # audio2 側の長さは同じ

              @progress_cop.next_step("序盤 BGM時間・音量調整")
              # strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -t #{part1} -af volume=#{params[:audio_part_a_volume]} -y _part1.m4a)
              strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -t #{part1_t} -af volume=#{params[:audio_part_a_volume]} -y _part1.m4a)
              logger.info { "_part1.m4a: #{Media.duration('_part1.m4a')}" }

              @progress_cop.next_step("終盤 BGM時間・音量調整")
              strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_b} -t #{part2_t} -af volume=#{params[:audio_part_b_volume]} -y _part2.m4a)
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
                  strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_x} -t #{total_duration} #{af} #{audio_bit_rate_o} -y _same_length1.m4a)
                  logger.info { "#{audio_part_x.basename}: #{Media.duration(audio_part_x)}" }
                  break
                end
              end
            end

            logger.info { "fadeout_duration: #{fadeout_duration}" }

            # logger.info { "全体の音量調整(しない)" }
            # strict_system %(ffmpeg -v warning -i _same_length1.m4a -af volume=#{main_volume} -y _same_length2.m4a)
            # logger.info { "_same_length2.m4a: #{Media.duration('_same_length2.m4a')}" }
          end

          logger.info { "3. 結合" }
          @progress_cop.next_step("BGM結合")
          strict_system %(ffmpeg -v warning -i _output2.mp4 -i _same_length1.m4a -c copy -y _output3.mp4)
          Pathname("_output3.mp4").read
        end
      end
    end

    private

    def fadeout_duration
      (params[:fadeout_duration].presence || (one_frame_duration_sec * end_frames)).to_f
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
      params[:main_volume]
    end

    def total_duration
      @frame_count * one_frame_duration_sec
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
        v = Shellwords.escape(v)
        "-b:a #{v}"
      end
    end

    def video_bit_rate_o
      if v = params[:video_bit_rate].presence
        v = Shellwords.escape(v)
        "-b:v #{v}"
      end
    end

    def audio_theme_info
      AudioThemeInfo.fetch_if(params[:audio_theme_key])
    end

    # def to_h
    #   {
    #     "最後に追加したフレーム数(end_frames)" => end_frames,
    #     "合計フレーム数(frame_count)"          => @frame_count,
    #     "1手当たりの秒数(one_frame_duration_sec)"  => one_frame_duration_sec,
    #     "予測した全体の秒数(total_duration)"   => total_duration,
    #     "BGMが切り替わるフレーム(switch_turn)" => @switch_turn,
    #   }
    # end
  end
end
