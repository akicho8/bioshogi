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
              begin
                list = Magick::ImageList.new
                list.concat([@image_renderer.next_build])
                @parser.move_infos.each.with_index do |e, i|
                  @mediator.execute(e[:input])
                  list.concat([@image_renderer.next_build]) # canvas は Magick::Image のインスタンス
                  logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
                end
                list.concat([@image_renderer.last_rendered_image] * end_frames)
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

              logger.info { "1. YUV420化" }
              strict_system %(ffmpeg -v warning -hide_banner -r #{fps_value} -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{ffmpeg_after_embed_options} -y _output1.mp4)
            end

            if media_factory_key == "ffmpeg"
              @frame_count = 0
              @image_renderer.next_build.write("_input%04d.png" % @frame_count)
              @frame_count += 1
              @parser.move_infos.each.with_index do |e, i|
                @mediator.execute(e[:input])
                logger.info("@mediator.execute OK")
                @image_renderer.next_build.write("_input%04d.png" % @frame_count)
                logger.info("@image_renderer.next_build.write OK")
                @frame_count += 1
                logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
              end
              end_frames.times do
                @image_renderer.last_rendered_image.write("_input%04d.png" % @frame_count)
                @frame_count += 1
              end
              logger.info { "合計フレーム数(frame_count): #{@frame_count}" }
              logger.info { "ソース画像生成数: " + `ls -alh _input*.png | wc -l`.strip }
              strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i _input%04d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{ffmpeg_after_embed_options} -y _output1.mp4)
              logger.info { `ls -alh _output1.mp4`.strip }
            end

            @image_renderer.clear_all
          end

          if !audio_part_a
            return Pathname("_output1.mp4").read
          end

          logger.tagged("audio") do
            logger.info { "2. BGM準備" }

            if @mediator.outbreak_turn
              @switch_turn = @mediator.outbreak_turn + 1 # 取った手の位置が欲しいので「取る直前」+ 1
              logger.info { "BGMが切り替わるフレーム(switch_turn): #{@switch_turn}" }
            end

            logger.info { "予測した全体の秒数(total_duration): #{total_duration}" }

            if @switch_turn && audio_part_b
              logger.info { "開戦前後で分ける" }
              part1 = @switch_turn * one_frame_duration_sec + acrossfade_duration # audio1 側を伸ばす
              part2 = (@frame_count - @switch_turn) * one_frame_duration_sec # audio2 側の長さは同じ

              # strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -t #{part1} -af volume=#{params[:audio_part_a_volume]} -y _part1.m4a)
              strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -t #{part1} -af volume=#{params[:audio_part_a_volume]} -y _part1.m4a)
              logger.info { "_part1.m4a: #{Media.duration('_part1.m4a')}" }

              strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_b} -t #{part2} -af volume=#{params[:audio_part_b_volume]} -y _part2.m4a)
              logger.info { "_part2.m4a: #{Media.duration('_part2.m4a')}" }

              strict_system %(ffmpeg -v warning -i _part1.m4a -i _part2.m4a -filter_complex #{cross_fade_option} _concat.m4a)
              strict_system %(ffmpeg -v warning -i _concat.m4a #{audio_filters(fadeout_value)} _same_length1.m4a)
            else
              logger.info { "開戦前のみ" }
              logger.info { "audio_part_a: #{audio_part_a}" }
              af = audio_filters("volume=#{params[:audio_part_a_volume]}", fadeout_value) # ボリューム調整 + ファイドアウト
              strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_part_a} -t #{total_duration} #{af} -y _same_length1.m4a)
              logger.info { "#{audio_part_a.basename}: #{Media.duration(audio_part_a)}" }
            end
            logger.info { "fadeout_duration: #{fadeout_duration}" }

            # logger.info { "全体の音量調整(しない)" }
            # strict_system %(ffmpeg -v warning -i _same_length1.m4a -af volume=#{main_volume} -y _same_length2.m4a)
            # logger.info { "_same_length2.m4a: #{Media.duration('_same_length2.m4a')}" }
          end

          logger.info { "3. 結合" }
          strict_system %(ffmpeg -v warning -i _output1.mp4 -i _same_length1.m4a -c copy -y _output2.mp4)
          Pathname("_output2.mp4").read
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
