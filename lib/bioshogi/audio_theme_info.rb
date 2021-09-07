# ボリュームは上げると音割れする場合があるため基本下げて調整する

module Bioshogi
  class AudioThemeInfo
    include ApplicationMemoryRecord
    memory_record [
      # ../../../shogi-extend/nuxt_side/components/Xmovie/models/color_theme_info.js
      # assets/audios
      { key: :audio_theme_none,                name: "無音",                            url: nil,                                              author: "",                     audio_part_a: nil,              audio_part_a_volume: nil, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_dance,               name: "ダンス系",                        url: nil,                                              author: "",                     audio_part_a: :headspin_long,   audio_part_a_volume: 0.7, audio_part_b: :breakbeat_long_strip, audio_part_b_volume: 1.0, acrossfade_duration: 1,   desc: "",                                          },
      { key: :audio_theme_war,                 name: "戦争系",                          url: nil,                                              author: "",                     audio_part_a: :mastermind,      audio_part_a_volume: 1.0, audio_part_b: :strategy,             audio_part_b_volume: 1.0, acrossfade_duration: 0,   desc: "",                                          },
      { key: :audio_theme_stg,                 name: "STG系(いまいち)",                 url: nil,                                              author: "",                     audio_part_a: :stg_like_type1a, audio_part_a_volume: 1.0, audio_part_b: :stg_like_type1b,      audio_part_b_volume: 1.0, acrossfade_duration: 1,   desc: "",                                          },
      { key: :audio_theme_headspin_only,       name: "ヘッドスピンのみ",                url: nil,                                              author: "",                     audio_part_a: :headspin_long,   audio_part_a_volume: 0.7, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_breakbeat_only,      name: "ブレイクビートのみ",              url: nil,                                              author: "",                     audio_part_a: :breakbeat_long,  audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_positive_think_only, name: "ポジシンピアノのみ",              url: nil,                                              author: "",                     audio_part_a: :positive_think,  audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc97718,             name: "てってってー",                    url: "https://commons.nicovideo.jp/material/nc97718",  author:  "ターリー◆dtTARy/mt2", audio_part_a: :nc97718,         audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc55257,             name: "３分クッキングのテーマソング",    url: "https://commons.nicovideo.jp/material/nc55257",  author: "ジェルバ",             audio_part_a: :nc55257,         audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc770,               name: "優しい風",                        url: "https://commons.nicovideo.jp/material/nc770",    author: "McCoy",                audio_part_a: :nc770,           audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc768,               name: "マーチ・マーチ",                  url: "https://commons.nicovideo.jp/material/nc768",    author: "McCoy",                audio_part_a: :nc768,           audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc43122,             name: "夜間航海",                        url: "https://commons.nicovideo.jp/material/nc43122",  author: "McCoy",                audio_part_a: :nc43122,         audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc799,               name: "夏の夜に-Piano solo-",            url: "https://commons.nicovideo.jp/material/nc799",    author: "McCoy",                audio_part_a: :nc799,           audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc35943,             name: "昼下がり",                        url: "https://commons.nicovideo.jp/material/nc35943",  author: "369",                  audio_part_a: :nc35943,         audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_nc3366,              name: "はてな",                          url: "https://commons.nicovideo.jp/material/nc3366",   author: "しましまP @shimakid",  audio_part_a: :nc3366,          audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc10812,             name: "BGM026 Jazz",                     url: "https://commons.nicovideo.jp/material/nc10812",  author: "sanche",               audio_part_a: :nc10812,         audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "ニコ生の作品以外では要連絡",                },
      { key: :audio_theme_nc105702,            name: "【ゆるい日常BGM】ぐだぐだな感じ", url: "https://commons.nicovideo.jp/material/nc105702", author: "yuki",                 audio_part_a: :nc105702,        audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_nc107860,            name: "Shall we meet？",                 url: "https://commons.nicovideo.jp/material/nc107860", author: "MATSU",                audio_part_a: :nc107860,        audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_ds7615,              name: "Winner",                          url: "https://dova-s.jp/bgm/play7615.html",            author: "FLASH☆BEAT",          audio_part_a: :ds7615,          audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_ds4712,              name: "昼下がり気分",                    url: "https://dova-s.jp/bgm/play4712.html",            author: "KK",                   audio_part_a: :ds4712,          audio_part_a_volume: 1.0, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "作者の紹介でYoutube動画に適しているとある", },
    ]

    def to_params
      {
        audio_part_a: real_path(audio_part_a),
        audio_part_b: real_path(audio_part_b),
        audio_part_a_volume: audio_part_a_volume,
        audio_part_b_volume: audio_part_b_volume,
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
