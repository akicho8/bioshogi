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
    cattr_accessor(:one_second) { 1000 } # ffmpeg の -r x/y の x の部分

    cattr_accessor :default_params do
      {
        :end_frames          => 0,   # 終了図だけ指定フレーム数停止
        :one_frame_duration         => 1.0, # 1手N秒
        :audio_enable        => true,
        :audio_file1         => "#{__dir__}/assets/audios/loop_bgm1.m4a",
        :audio_file2         => "#{__dir__}/assets/audios/loop_bgm2.m4a",
        :fadeout_duration    => 3,   # audio_file1 の最後のファイドアウト秒数
        :tmpdir_remove       => true, # 作業ディレクトリを最後に削除する
        :acrossfade_duration => 2.0,  # 0なら結合
      }
    end

    attr_accessor :parser
    attr_accessor :params

    delegate :logger, to: "Bioshogi"

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
    end

    def to_binary
      require "rmagick"
      dir = Dir.mktmpdir
      logger&.debug("cd #{dir}")

      Dir.chdir(dir) do
        mediator = parser.mediator_for_image
        image_formatter = ImageFormatter.new(mediator, params)

        begin
          list = Magick::ImageList.new
          image_formatter.render
          list.concat([image_formatter.canvas])
          parser.move_infos.each.with_index do |e, i|
            mediator.execute(e[:input])
            image_formatter.render
            list.concat([image_formatter.canvas]) # canvas は Magick::Image のインスタンス
            logger&.debug("move: #{i.next} / #{parser.move_infos.size}") if i.modulo(10).zero?
          end
          list.concat([image_formatter.canvas] * params[:end_frames])
          list.write("_output0.mp4")
          logger&.debug("_output0.mp4: #{Media.duration('_output0.mp4')}") if false
          @switch_turn = mediator.outbreak_turn + 1 # 取った手の位置が欲しいので「取る直前」+ 1
          @frame_count = list.count
        ensure
          list.destroy!       # 恐いので明示的に解放しとこう
        end

        logger&.debug("frame_count: #{@frame_count}")
        logger&.debug("one_frame_duration: #{one_frame_duration}")
        logger&.debug("total_d: #{total_d}")
        logger&.debug("switch_turn: #{@switch_turn}")

        # 1. YUV420化
        strict_system %(ffmpeg -v warning -hide_banner #{fps_option} -y -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -y _output1.mp4)
        if !params[:audio_enable]
          return Pathname("_output1.mp4").read
        end

        # 2. BGM準備
        # ffmpeg -v warning -stream_loop -1 -i #{audio_file1} -t #{total_d} -c copy -y _long.m4a
        # ffmpeg -v warning -i _long.m4a -af "afade=t=out:st=6:d=2" -y _same_lengh.m4a

        if @switch_turn
          part1 = @switch_turn * one_frame_duration + acrossfade_duration # audio1 側を伸ばす
          part2 = (@frame_count - @switch_turn) * one_frame_duration # audio2 側の長さは同じ
          strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_file1} -t #{part1} -c copy -y _part1.m4a)
          logger&.debug("_part1.m4a: #{Media.duration('_part1.m4a')}")
          strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_file2} -t #{part2} -c copy -y _part2.m4a)
          logger&.debug("_part2.m4a: #{Media.duration('_part2.m4a')}")
          strict_system %(ffmpeg -v warning -i _part1.m4a -i _part2.m4a -filter_complex #{filter_complex_value} _concat.m4a)
          strict_system %(ffmpeg -v warning -i _concat.m4a #{audio_filter} _same_lengh.m4a)
        else
          logger&.debug("audio_file1: #{audio_file1}")
          strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_file1} -t #{total_d} #{audio_filter} -y _same_lengh.m4a)
          logger&.debug("#{audio_file1.basename}: #{Media.duration(audio_file1)}")
        end
        logger&.debug("_same_lengh.m4a: #{Media.duration('_same_lengh.m4a')}")

        # 3. 結合
        strict_system %(ffmpeg -v warning -i _output1.mp4 -i _same_lengh.m4a -c copy -y _output2.mp4)
        Pathname("_output2.mp4").read
      end
    ensure
      if dir
        if params[:tmpdir_remove]
          logger&.debug("rm -fr #{dir}")
          FileUtils.remove_entry_secure(dir)
        end
      end
    end

    private

    # 1手 0.5 秒 → "-r 60/30"
    # 1手 1.0 秒 → "-r 60/60"
    # 1手 1.5 秒 → "-r 60/90"
    def fps_option
      v = (one_second * one_frame_duration).to_i
      "-r #{one_second}/#{v}" # -framerate だと動かない。-framerate は連番のとき用っぽい
    end

    def one_frame_duration
      params[:one_frame_duration].to_f
    end

    def fadeout_duration
      params[:fadeout_duration].to_f
    end

    def audio_file1
      if v = params[:audio_file1]
        Pathname(v).expand_path
      end
    end

    def audio_file2
      if v = params[:audio_file2]
        Pathname(v).expand_path
      end
    end

    def acrossfade_duration
      params[:acrossfade_duration].to_f
    end

    def total_d
      @frame_count * one_frame_duration
    end

    def audio_filter
      if fadeout_duration > 0
        %(-af "afade=t=out:start_time=#{total_d - fadeout_duration}:duration=#{fadeout_duration}")
      end
    end

    # 長さ d=0 にしてもクロスフェイド効果があるっぽいので 0 なら単に結合する
    def filter_complex_value
      if acrossfade_duration > 0
        %("acrossfade=duration=#{acrossfade_duration}")
      else
        %("concat=n=2:v=0:a=1")
      end
    end

    def strict_system(command)
      require "systemu"
      time = Time.now
      logger&.debug("run: #{command}")
      status, stdout, stderr = systemu(command) # 例外は出ないのでensure不要
      logger&.debug("status: #{status}") if !status.success?
      logger&.debug("elapsed: #{(Time.now - time).round}s")
      logger&.debug("stderr: #{stderr}") if stderr.present?
      logger&.debug("stdout: #{stdout}") if stdout.present?
      if !status.success?
        raise StandardError, stderr.strip
      end
    end
  end
end
