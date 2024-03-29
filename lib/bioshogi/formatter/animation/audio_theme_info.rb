# ボリュームは上げると音割れする場合があるため基本下げて調整する
module Bioshogi
  module Formatter
    module Animation
      class AudioThemeInfo
        include ApplicationMemoryRecord
        memory_record [
          # ../../../shogi-extend/nuxt_side/components/Kiwi/models/audio_theme_info.js
          # assets/audios
          { key: :is_audio_theme_none,           name: "無音",                                  source_url: nil,                                           author: nil,                 audio_part_a: nil,                  audio_part_a_volume: nil, audio_part_a_duration:    nil, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
          { key: :is_audio_theme_breakbeat_only, name: "ブレイクビート",                        source_url: nil,                                           author: nil,                 audio_part_a: :breakbeat_long,      audio_part_a_volume: 1.0, audio_part_a_duration:  35.55, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
          { key: :is_audio_theme_dance_chain,    name: "ヘッドスピン→ブレイクビート",          source_url: nil,                                           author: nil,                 audio_part_a: :headspin_long,       audio_part_a_volume: 1.0, audio_part_a_duration:  28.05, audio_part_a_loop: false, audio_part_b: :breakbeat_long_strip, audio_part_b_volume: 1.0, acrossfade_duration: 1,   desc: "",                                          },
          { key: :is_audio_theme_diamond_shark,  name: "Diamond Shark",                         source_url: "https://www.youtube.com/watch?v=JZMHhmDwauk", author: "27Corazones Beats", audio_part_a: :diamond_shark,       audio_part_a_volume: 1.0, audio_part_a_duration: 3*60+12,  audio_part_a_loop: false,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                      },
          { key: :is_audio_theme_ds11184,        name: "Gliese (Prod. Khaim)",                  source_url: "https://dova-s.jp/bgm/play11184.html",        author: "Khaim",             audio_part_a: :ds11184,             audio_part_a_volume: 1.0, audio_part_a_duration: 157.13, audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
          { key: :is_audio_theme_ds13037,        name: "YouTube向けラグタイム",                 source_url: "https://dova-s.jp/bgm/play13037.html",        author: "天休ひさし",        audio_part_a: :ds13037,             audio_part_a_volume: 1.0, audio_part_a_duration:  96.02, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
          { key: :is_audio_theme_ds14640,        name: "しゅわしゅわハニーレモン350ml",         source_url: "https://dova-s.jp/bgm/play14640.html",        author: "しゃろう",          audio_part_a: :ds14640, audio_part_a_volume: 1.0, audio_part_a_duration:  60+36,  audio_part_a_loop: true, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "", },
          { key: :is_audio_theme_ds1982,         name: "8-bit Aggressive1",                     source_url: "https://dova-s.jp/bgm/play1982.html",         author: "もっぴーさうんど",  audio_part_a: :ds1982,              audio_part_a_volume: 1.0, audio_part_a_duration: 60*1+58, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "", },
          { key: :is_audio_theme_ds3479,         name: "Blue Ever",                             source_url: "https://dova-s.jp/bgm/play3479.html",         author: "Khaim",             audio_part_a: :ds3479,              audio_part_a_volume: 1.0, audio_part_a_duration: 56.03,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
          { key: :is_audio_theme_ds3812,         name: "Three Keys (Freestyle Rap Beat No.02)", source_url: "https://dova-s.jp/bgm/play3812.html",         author: "Khaim",             audio_part_a: :ds3812,              audio_part_a_volume: 1.0, audio_part_a_duration: 237.72, audio_part_a_loop: false,  audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
          { key: :is_audio_theme_ds4520,         name: "わくわくクッキングタイム的なBGM",       source_url: "https://dova-s.jp/bgm/play4520.html",         author:  "鷹尾まさき",       audio_part_a: :ds4520,  audio_part_a_volume: 1.0, audio_part_a_duration: 61.205,   audio_part_a_loop: false,  audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: "", },
          { key: :is_audio_theme_headspin_only,  name: "ヘッドスピン",                          source_url: nil,                                           author: nil,                 audio_part_a: :headspin_long,       audio_part_a_volume: 1.0, audio_part_a_duration:  28.05, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
        ]

        def to_params
          {
            :audio_part_a        => audio_part_a,
            :audio_part_a_volume => audio_part_a_volume,
            :audio_part_b        => audio_part_b,
            :audio_part_b_volume => audio_part_b_volume,
            :acrossfade_duration => acrossfade_duration,
            :bottom_text         => bottom_text,
          }
        end

        def audio_part_a
          real_path(super)
        end

        def audio_part_b
          real_path(super)
        end

        # ruby -I lib -r bioshogi -e 'tp Bioshogi::AudioThemeInfo.collect{ |e| [e.key, e.native_duration&.round(2)] }.to_h'
        # |---------------------------------+--------|
        # |                is_audio_theme_none |        |
        # |       is_audio_theme_headspin_only | 28.05  |
        # |      is_audio_theme_breakbeat_only | 35.55  |
        # |         is_audio_theme_dance_chain | 28.05  |
        # |             is_audio_theme_nc97718 | 24.0   |
        # |              is_audio_theme_ds4712 | 235.26 |
        # |            is_audio_theme_nc105702 | 94.15  |
        # |            is_audio_theme_nc107860 | 69.85  |
        # |              is_audio_theme_ds5616 | 113.59 |
        # |            is_audio_theme_nc142538 | 95.66  |
        # |  is_audio_theme_shw_akatsuki_japan | 236.64 |
        # |              is_audio_theme_ds3895 | 133.7  |
        # |              is_audio_theme_ds1245 | 96.05  |
        # |              is_audio_theme_ds7138 | 36.05  |
        # |              is_audio_theme_ds3812 | 237.72 |
        # |              is_audio_theme_ds3480 | 55.44  |
        # |             is_audio_theme_ds11184 | 157.13 |
        # |              is_audio_theme_ds6574 | 174.6  |
        # |---------------------------------+--------|
        def native_duration
          if audio_part_a
            Media.duration(audio_part_a)
          end
        end

        def valid?
          errors = 0
          if audio_part_a && !audio_part_a.exist?
            errors += 1
          end
          if audio_part_b && !audio_part_b.exist?
            errors += 1
          end
          errors == 0
        end

        private

        def real_path(basename)
          if basename
            ASSETS_DIR.join("audios/#{basename}.m4a")
          end
        end

        def bottom_text
          if author
            "BGM: #{name} by #{author}"
          end
        end
      end
    end
  end
end
