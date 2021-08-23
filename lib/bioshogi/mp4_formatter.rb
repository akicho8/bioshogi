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
  class Mp4Formatter
    include FormatterUtils

    cattr_accessor(:one_second) { 1000 } # ffmpeg の -r x/y の x の部分

    cattr_accessor :default_params do
      {
        # 全体
        :one_frame_duration  => 1.0,  # 1手N秒
        :end_duration        => 0,    # 終了図をN秒表示する
        :end_frames          => nil,  # 終了図追加フレーム数。空なら end_duration / one_frame_duration

        # Audio関連
        :audio_enable        => true, # 音を結合するか？
        :fadeout_duration    => nil,  # ファイドアウト秒数。空なら end_frames * one_frame_duration
        # :main_volume         => 1.0,  # 音量

        # テーマ関連
        :audio_theme_key     => nil,  # テーマみたいなものでパラメータを一括設定するキー。audio_theme_none なら明示的にオーディオなしにするけど、nilなら何もしない
        :audio_part_a        => "#{__dir__}/assets/audios/headspin_long.m4a",        # 序盤
        :audio_part_b        => "#{__dir__}/assets/audios/breakbeat_long_strip.m4a", # 中盤移行
        :audio_part_a_volume => 1.0,
        :audio_part_b_volume => 1.0,
        :acrossfade_duration => 2.0,  # 0なら単純な連結

        # 他
        :ffmpeg_after_embed_options => nil,  # ffmpegコマンドの YUV420 変換の際に最後に埋めるコマンド(-crt )
        :tmpdir_remove              => true, # 作業ディレクトリを最後に削除するか？ (デバッグ時にはfalseにする)
        :mp4_factory_key            => "ffmpeg", # rmagick or ffmpeg
      }
    end

    attr_accessor :parser
    attr_accessor :params
    attr_accessor :logger

    delegate :logger, to: "Bioshogi"

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
      if audio_theme_info
        @params.update(audio_theme_info.to_params)
      end
      # theme を上書きする用
      if v = params[:theme_override_params]
        @params.update(v)
      end
    end

    # リファクタリングしたくなる気持ちを抑えよう(重要)
    def to_binary
      logger.tagged("mp4_formatter") do
        begin
          dir = Dir.mktmpdir
          require "rmagick"
          logger.info { "cd #{dir}" }

          Dir.chdir(dir) do
            logger.tagged("video") do
              logger.info { "1. 動画準備" }

              logger.info { "MP4生成に使うもの: #{mp4_factory_key}" }
              logger.info { "最後に追加するフレーム数(end_frames): #{end_frames}" }
              logger.info { "1手当たりの秒数(one_frame_duration): #{one_frame_duration}" }

              @mediator = @parser.mediator_for_image
              @image_formatter = ImageFormatter.new(@mediator, params)

              if mp4_factory_key == "rmagick"
                begin
                  list = Magick::ImageList.new
                  @image_formatter.render
                  list.concat([@image_formatter.canvas])
                  @parser.move_infos.each.with_index do |e, i|
                    @mediator.execute(e[:input])
                    @image_formatter.render
                    list.concat([@image_formatter.canvas]) # canvas は Magick::Image のインスタンス
                    logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
                  end
                  list.concat([@image_formatter.canvas] * end_frames)
                  logger.info { "write[begin]: _output0.mp4" }
                  begin
                    list.write("_output0.mp4") # staging ではここで例外も出さずに落ちることがある
                  rescue Exception => error
                    logger.info { "error: #{error}" }
                    raise error
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
                logger.info { "write[begin]: _output1.mp4" }
                strict_system %(ffmpeg -v warning -hide_banner -framerate #{fps_value} -i _input%03d.png -c:v libx264 -pix_fmt yuv420p -movflags +faststart #{ffmpeg_after_embed_options} -y _output1.mp4)
                logger.info { "write[end]: _output1.mp4" }
                logger.info { `ls -alh _output1.mp4`.strip }
              end
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
                part1 = @switch_turn * one_frame_duration + acrossfade_duration # audio1 側を伸ばす
                part2 = (@frame_count - @switch_turn) * one_frame_duration # audio2 側の長さは同じ

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
        ensure
          if params[:tmpdir_remove]
            logger.info { "rm -fr #{dir}" }
            FileUtils.remove_entry_secure(dir)
          end
        end
      end
    end

    
    private

    # 1手 0.5 秒 → "-r 60/30"
    # 1手 1.0 秒 → "-r 60/60"
    # 1手 1.5 秒 → "-r 60/90"
    # def fps_value
    #   v = (one_second * one_frame_duration).to_i
    #   "-r #{fps_value2}" # -framerate だと動かない。-framerate は連番のとき用っぽい
    # end
    def fps_value
      v = (one_second * one_frame_duration).to_i
      "#{one_second}/#{v}"
    end

    def ffmpeg_after_embed_options
      params[:ffmpeg_after_embed_options]
    end

    def one_frame_duration
      params[:one_frame_duration].to_f
    end

    def fadeout_duration
      (params[:fadeout_duration].presence || (one_frame_duration * end_frames)).to_f
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

    # 最後の局面を追加で足す回数
    # これを設定しても最終的な秒数は不明なため基本指定せず、指定した end_duration から算出した方がよい
    # |----------------+--------------------+-----------+-----+----------------|
    # | 伸ばしたい秒数 |             1手N秒 |           |     | 追加フレーム数 |
    # |   end_duration | one_frame_duration |           |     |     end_frames |
    # |----------------+--------------------+-----------+-----+----------------|
    # |            2.0 |                0.4 | 2.0 / 0.4 | 5.0 |              5 |
    # |            2.0 |                0.5 | 2.0 / 0.5 | 4.0 |              4 |
    # |            2.0 |                0.6 | 2.0 / 0.6 | 3.3 |              4 |
    # |            2.0 |                0.9 | 2.0 / 0.9 | 2.2 |              3 |
    # |            2.0 |                1.0 | 2.0 / 1.0 | 2.0 |              2 |
    # |            2.0 |                1.1 | 2.0 / 1.1 | 1.8 |              2 |
    # |            2.0 |                2.0 | 2.0 / 2.0 | 1.0 |              1 |
    # |            2.0 |                3.0 | 2.0 / 3.0 | 0.6 |              1 |
    # |            2.0 |                4.0 | 2.0 / 4.0 | 0.5 |              1 |
    # |            0.1 |                1.0 | 0.1 / 1.0 | 0.1 |              1 |
    # |            0.0 |                1.0 | 0.0 / 1.0 | 0.0 |              0 |
    # |            0.0 |                0.0 | 0.0 / 0.0 | ERR |                |
    # |----------------+--------------------+-----------+-----+----------------|
    # 伸ばしたい秒数分だけ手が必要なので「伸ばす秒数/1手秒数」で追加フレーム数がわかる
    # ただ1手の秒数より伸ばす秒数が少ないと繰り上げる必要がある
    def end_frames
      if v = params[:end_frames]
        v.to_i
      else
        params[:end_duration].fdiv(one_frame_duration).ceil
      end
    end

    def total_duration
      @frame_count * one_frame_duration
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

    def mp4_factory_key
      params.fetch(:mp4_factory_key).to_s
    end

    # def to_h
    #   {
    #     "最後に追加したフレーム数(end_frames)" => end_frames,
    #     "合計フレーム数(frame_count)"          => @frame_count,
    #     "1手当たりの秒数(one_frame_duration)"  => one_frame_duration,
    #     "予測した全体の秒数(total_duration)"   => total_duration,
    #     "BGMが切り替わるフレーム(switch_turn)" => @switch_turn,
    #   }
    # end

    def strict_system(command)
      logger.tagged("execute") do
        require "systemu"
        time = Time.now
        logger.info { command }
        status, stdout, stderr = systemu(command) # 例外は出ないのでensure不要
        logger.info { "status: #{status}" } if !status.success?
        logger.info { "elapsed: #{(Time.now - time).round}s" }
        logger.info { "stderr: #{stderr}" } if stderr.present?
        logger.info { "stdout: #{stdout}" } if stdout.present?
        if !status.success?
          raise StandardError, stderr.strip
        end
      end
    end
  end
end
