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
        :end_frames     => 0,   # 終了図だけ指定フレーム数停止
        :video_speed    => 1.0, # 1手N秒
        :audio_file     => "#{__dir__}/assets/audios/loop_bgm1.m4a",
        :fadeout_second => 3,   # audio_file の最後のファイドアウト秒数
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
          parser.move_infos.each do |e|
            mediator.execute(e[:input])
            image_formatter.render
            list.concat([image_formatter.canvas]) # canvas は Magick::Image のインスタンス
          end
          list.concat([image_formatter.canvas] * params[:end_frames])
          frame_count = list.count
          list.write("_output0.mp4")
        ensure
          list.destroy!       # 恐いので明示的に解放しとこう
        end

        # 1. YUV420化
        strict_system %(ffmpeg -v warning -hide_banner #{fps_option} -y -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -y _output1.mp4)
        if !audio_file
          return Pathname("_output1.mp4").read
        end

        # 2. BGM準備
        # ffmpeg -v warning -stream_loop -1 -i #{audio_file} -t #{total} -c copy -y _long.m4a
        # ffmpeg -v warning -i _long.m4a -af "afade=t=out:st=6:d=2" -y _same_lengh.m4a
        logger&.debug("audio_file: #{audio_file}")
        total = frame_count * video_speed
        if fadeout_second > 0
          start = total - fadeout_second
          audio_filter = %(-af "afade=t=out:st=#{start}:d=#{fadeout_second}")
        else
          audio_filter = ""
        end
        strict_system %(ffmpeg -v warning -stream_loop -1 -i #{audio_file} -t #{total} #{audio_filter} -y _same_lengh.m4a)
        logger&.debug("#{audio_file.basename}: #{Media.duration(audio_file)}")
        logger&.debug("_same_lengh.m4a: #{Media.duration('_same_lengh.m4a')}")

        # 3. 結合
        strict_system %(ffmpeg -v warning -i _output1.mp4 -i _same_lengh.m4a -c copy -y _output2.mp4)
        Pathname("_output2.mp4").read
      end
    ensure
      if dir
        logger&.debug("rm -fr #{dir}")
        FileUtils.remove_entry_secure(dir)
      end
    end

    private

    # 1手 0.5 秒 → "-r 60/30"
    # 1手 1.0 秒 → "-r 60/60"
    # 1手 1.5 秒 → "-r 60/90"
    def fps_option
      v = (one_second * video_speed).to_i
      "-r #{one_second}/#{v}" # -framerate だと動かない。-framerate は連番のとき用っぽい
    end

    def video_speed
      params[:video_speed].to_f
    end

    def fadeout_second
      params[:fadeout_second].to_f
    end

    def audio_file
      if v = params[:audio_file]
        Pathname(v).expand_path
      end
    end

    def strict_system(command)
      require "systemu"
      time = Time.now
      logger&.debug(command)
      status, stdout, stderr = systemu(command) # 例外は出ないのでensure不要
      logger&.debug("#{status}")
      logger&.debug("#{(Time.now - time).round}s")
      logger&.debug("stderr: #{stderr}") if stderr.present?
      logger&.debug("stdout: #{stdout}") if stdout.present?
      if !status.success?
        raise StandardError, stderr.strip
      end
    end
  end
end
