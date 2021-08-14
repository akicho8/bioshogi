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
      # animation_formatter は使わずにここで書けばいいんじゃないか？
      # e = @parser.animation_formatter(params.merge(animation_format: "mp4", delay_per_one: 0))
      # bin = e.to_write_binary
      bin = rmagick_mp4
      in_out_tempfile do |i, o|
        i.write(bin)
        command = ffmpeg_command(i, o)
        strict_system(command)
      end
    end

    private

    def rmagick_mp4
      require "rmagick"

      mediator = Mediator.new         # MediatorFast にしても45秒が44秒になる程度
      mediator.params.update({
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
          :candidate_enable               => false,
          :validate_enable                => false,
        })
      parser.mediator_board_setup(mediator) # FIXME: これ、必要ない SFEN を生成したりして遅い

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
      # @list.delay = @list.ticks_per_second * params[:delay_per_one]
      # @list = @list.coalesce                               # 全ページを1ページ目のフレームサイズにする
      # if params[:optimize_layer]
      @list = @list.optimize_layers(Magick::OptimizeLayer) # 各ページを最小枠にする
      #
      # @list.iterations = iterations_number  # 繰り返し回数

      Tempfile.create(["", ".mp4"]) do |t|
        @list.write(t.path)
        @list.destroy!
        File.read(t.path)
      end
    end

    # fps_option (-r) は -i より前
    def ffmpeg_command(in_file, out_file)
      "ffmpeg -v warning -hide_banner #{fps_option} -y -i #{in_file} -vcodec libx264 -pix_fmt yuv420p #{out_file}"
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
      if v = params[:video_speed].presence
        v = (one_second * v.to_f).to_i
        "-r #{one_second}/#{v}"
      end
    end

    def in_out_tempfile
      Tempfile.create(["i_", ".mp4"]) do |i|
        Tempfile.create(["o_", ".mp4"]) do |o|
          i = Pathname(i.path)
          o = Pathname(o.path)
          yield i, o
          o.read
        end
      end
    end

    def strict_system(command)
      status, stdout, stderr = systemu(command)
      if !status.success?
        raise StandardError, stderr.strip
      end
    end
  end
end
