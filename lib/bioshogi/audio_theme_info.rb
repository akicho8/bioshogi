module Bioshogi
  class AudioThemeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :audio_theme_a, audio_file1: :loop_bgm1, audio_file2: :loop_bgm2, },
      { key: :audio_theme_b, audio_file1: :loop_bgm1, audio_file2: :loop_bgm2, },
    ]

    def to_options
      {
        audio_file1: real_path(audio_file1),
        audio_file2: real_path(audio_file2),
      }
    end

    private

    def real_path(basename)
      "#{__dir__}/assets/audios/#{basename}.m4a"
    end
  end
end
