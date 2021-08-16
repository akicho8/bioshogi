# ruby 0102_speed_compare.rb
# 7819.15000002482
# 9034.157999994932
# -rw------- 1 ikeda staff  60K  8 16 19:16 _output0.mp4
# -rw-r--r-- 1 ikeda staff 119K  8 16 19:16 _output1_1.mp4
# -rw-r--r-- 1 ikeda staff 135K  8 16 19:17 _output1_2.mp4

require "systemu"

module Bioshogi
  class Mp4Formatter
    cattr_accessor(:one_second) { 1000 } # ffmpeg の -r x/y の x の部分

    cattr_accessor :default_params do
      {
        :end_frames  => 0,   # 終了図だけ指定フレーム数停止
        :video_speed => 1.0, # 1手N秒
      }
    end

    attr_accessor :parser
    attr_accessor :params

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
    end

    def to_binary
      require "rmagick"
      begin
        dir = Dir.mktmpdir
        puts dir

        Dir.chdir(dir) do
          mediator = parser.mediator_for_image
          image_formatter = ImageFormatter.new(mediator, params)

          @list = Magick::ImageList.new
          image_formatter.render
          @list.concat([image_formatter.canvas])
          parser.move_infos.each do |e|
            mediator.execute(e[:input])
            image_formatter.render
            @list.concat([image_formatter.canvas]) # canvas は Magick::Image のインスタンス
          end
          @list.concat([image_formatter.canvas] * params[:end_frames])
          frame_count = @list.count

          @list.write("_output0.mp4")
          @list.destroy!

          # puts `duration _output1.mp4`

          strict_system %(ffmpeg -v warning -hide_banner #{fps_option} -y -i _output0.mp4 -c:v libx264 -pix_fmt yuv420p -y _output1_yuv420.mp4)

          loop_bgm = Pathname("#{__dir__}/loop_bgm.m4a")

          #   # # 5秒の素材を繰り返して8秒(正確に8秒ではない)のBGMを作る
          total = frame_count * video_speed
          fadein = 0
          fadeout = 5
          st = total - fadeout
          # 
          # strict_system %(ffmpeg -v warning -stream_loop -1 -i #{loop_bgm} -t #{total} -c copy -y _fade.m4a)
          # afade=t=in:st=0:d=#{fadeout},
          strict_system %(ffmpeg -v warning -stream_loop -1 -i #{loop_bgm} -t #{total} -af "afade=t=out:st=#{st}:d=#{fadeout}" -y _fade.m4a)
          # puts `duration loop_bgm.m4a`         # => "3.018594\n"
          puts `duration _fade.m4a`            # => "8.0\n"

          # # # 前後をフェイドアウトさせる(処理は↑と一体化できる)
          # # ffmpeg -v warning -i _long.m4a -af "afade=t=in:st=0:d=1,afade=t=out:st=6:d=2" -y _fade.m4a
          #
          # # # 結合する
          strict_system %(ffmpeg -v warning -i _output1_yuv420.mp4 -i _fade.m4a -c copy -y _output2.mp4)
          # `open -a 'google chrome' _output2.mp4`

          Pathname("_output2.mp4").read
        end
      ensure
        FileUtils.remove_entry_secure(dir)
      end
    end

    private

    # fps_option (-r) は -i より前
    def ffmpeg_command(in_file, out_file)
    end

    # def fps_option
    #   # fps_option1 || fps_option2
    # end

    # フレームレートを指定値に変換する。指定しない場合は入力ファイルの値を継承
    # http://mobilehackerz.jp/archive/wiki/index.php?%BA%C7%BF%B7ffmpeg%A4%CE%A5%AA%A5%D7%A5%B7%A5%E7%A5%F3%A4%DE%A4%C8%A4%E1
    # 小数で指定してはいけない
    #
    # FFMPEG でのフレームレート設定の違い
    # https://nico-lab.net/setting_fps_with_ffmpeg/
    # 入力オプションとしての -r
    # 入力ファイルの前に指定する。総フレーム数はそのままに1秒あたりのフレームレートを指定するので、オリジナルよりフレームレートが少なければ動画時間が長く、多ければ動画時間が短くなる。
    # def fps_option1
    #   # if v = params[:video_fps].presence
    #   #   "-r #{v}"
    #   # end
    # end

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

    def strict_system(command)
      puts command
      status, stdout, stderr = systemu(command)
      if !status.success?
        raise StandardError, stderr.strip
      end
    end
  end
end
