module Bioshogi
  class AudioThemeInfo
    include ApplicationMemoryRecord
    memory_record [
      # assets/audios
      { key: :audio_theme_none,                name: "無音",               audio_part_a: nil,              audio_part_b: nil,                   acrossfade_duration: nil, },
      { key: :audio_theme_dance,               name: "ダンス系",           audio_part_a: :headspin_long,   audio_part_b: :breakbeat_long_strip, acrossfade_duration: 1,   },
      { key: :audio_theme_war,                 name: "戦争系",             audio_part_a: :mastermind,      audio_part_b: :strategy,             acrossfade_duration: 0,   },
      { key: :audio_theme_stg,                 name: "STG系(いまいち)",    audio_part_a: :stg_like_type1a, audio_part_b: :stg_like_type1b,      acrossfade_duration: 1,   },
      { key: :audio_theme_breakbeat_only,      name: "ブレイクビートのみ", audio_part_a: :breakbeat_long,  audio_part_b: nil,                   acrossfade_duration: nil, },
      { key: :audio_theme_headspin_only,       name: "ヘッドスピンのみ",   audio_part_a: :headspin_long,   audio_part_b: nil,                   acrossfade_duration: nil, },
      { key: :audio_theme_positive_think_only, name: "ポジシンピアノのみ", audio_part_a: :positive_think,  audio_part_b: nil,                   acrossfade_duration: nil, },
    ]

    def to_params
      {
        audio_part_a: real_path(audio_part_a),
        audio_part_b: real_path(audio_part_b),
        acrossfade_duration: acrossfade_duration,
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
