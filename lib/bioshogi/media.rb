module Bioshogi
  module Media
    extend self

    def duration(file)
      info = JSON.parse(`ffprobe -v warning -print_format json -show_entries format=duration #{file}`)
      info["format"]["duration"].to_f
    end

    # def video_bit_rate(file)
    #   info = JSON.parse(`ffprobe -v warning -print_format json -show_entries format=bit_rate #{file}`)
    #   info["format"]["bit_rate"].to_f
    # end

    def pretty_inspect(file)
      JSON.parse(`ffprobe -v warning -pretty -print_format json -show_streams #{file}`)
    end

    def inspect(file)
      `ffprobe -hide_banner #{file} 2>&1 | grep Stream`
    end

    def p(file)
      puts inspect(file)
    end

    def format(file)
      JSON.parse(`ffprobe -v warning -pretty -print_format json -show_format #{file}`)["format"]
    end

    def tags(file)
      format(file)["tags"]
    end

    def video_inspect(file)
      info = pretty_inspect(file)
      info["streams"].find { |e| e["codec_type"] == "video" }
    end

    def video_bit_rate(file)
      if e = video_inspect(file)
        e["bit_rate"]
      end
    end

    def audio_inspect(file)
      info = pretty_inspect(file)
      info["streams"].find { |e| e["codec_type"] == "audio" }
    end

    def audio_bit_rate(file)
      if e = audio_inspect(file)
        e["bit_rate"]
      end
    end

    # [Parsed_volumedetect_0 @ 0x7fd26b623100] n_samples: 423808
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] mean_volume: -16.1 dB
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] max_volume: -0.1 dB
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] histogram_0db: 44
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] histogram_1db: 71
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] histogram_2db: 71
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] histogram_3db: 242
    def volume_info(file)
      `ffmpeg -hide_banner -i #{file} -vn -af volumedetect -f null - 2>&1`
    end

    # あとどれだけボリュームを上げられるか
    # [Parsed_volumedetect_0 @ 0x7fd26b623100] max_volume: -0.1 dB
    # であれば 0.1 上げられる
    def enough_volume(file)
      md = volume_info(file).match(/max_volume:\s*(\S+)/)
      md.captures.first.to_f * -1
    end
  end
end
