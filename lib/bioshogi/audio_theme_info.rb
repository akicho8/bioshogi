module Bioshogi
  class AudioThemeInfo
    include ApplicationMemoryRecord
    memory_record [
      # assets/audios
      { key: :audio_theme_a, audio_part_a: :loop_bgm_aa, audio_part_b: :loop_bgm_ab, },
      { key: :audio_theme_b, audio_part_a: :loop_bgm_ba, audio_part_b: :loop_bgm_bb, },
      { key: :audio_theme_c, audio_part_a: :loop_bgm_ca, audio_part_b: :loop_bgm_cb, },
      { key: :audio_theme_d, audio_part_a: :loop_bgm_da, audio_part_b: nil,          },
      { key: :audio_theme_e, audio_part_a: :breakbeat_long, audio_part_b: nil,          },
      { key: :audio_theme_f, audio_part_a: :headspin_long, audio_part_b: nil,          },
      { key: :audio_theme_g, audio_part_a: :loop_bgm_ga, audio_part_b: nil,          },
      { key: :audio_theme_h, audio_part_a: :headspin_long, audio_part_b: :breakbeat_long_strip, },
    ]

    def to_params
      {
        audio_part_a: real_path(audio_part_a),
        audio_part_b: real_path(audio_part_b),
      }
    end

    private

    def real_path(basename)
      if basename
        "#{__dir__}/assets/audios/#{basename}.m4a"
      end
    end
  end
end
