# ボリュームは上げると音割れする場合があるため基本下げて調整する

module Bioshogi
  class AudioThemeInfo
    include ApplicationMemoryRecord
    memory_record [
      # ../../../shogi-extend/nuxt_side/components/Xmovie/models/audio_theme_info.js
      # assets/audios
      { key: :audio_theme_is_none,                name: "無音",                                  source_url: nil,                                              author: nil,                    audio_part_a: nil,                  audio_part_a_volume: nil, audio_part_a_duration:    nil, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_headspin_only,       name: "ヘッドスピン",                          source_url: nil,                                              author: nil,                    audio_part_a: :headspin_long,       audio_part_a_volume: 0.7, audio_part_a_duration:  28.05, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_breakbeat_only,      name: "ブレイクビート",                        source_url: nil,                                              author: nil,                    audio_part_a: :breakbeat_long,      audio_part_a_volume: 1.0, audio_part_a_duration:  35.55, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_dance_chain,         name: "ヘッドスピン→ブレイクビート",          source_url: nil,                                              author: nil,                    audio_part_a: :headspin_long,       audio_part_a_volume: 0.7, audio_part_a_duration:  28.05, audio_part_a_loop: false, audio_part_b: :breakbeat_long_strip, audio_part_b_volume: 1.0, acrossfade_duration: 1,   desc: "",                                          },

      { key: :audio_theme_is_nc97718,             name: "てってってー",                          source_url: "https://commons.nicovideo.jp/material/nc97718",  author: "ターリー◆dtTARy/mt2", audio_part_a: :nc97718,             audio_part_a_volume: 1.0, audio_part_a_duration:  24.0,  audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_nc768,               name: "マーチ・マーチ",                        source_url: "https://commons.nicovideo.jp/material/nc768",    author: "McCoy",                audio_part_a: :nc768,               audio_part_a_volume: 1.0, audio_part_a_duration: 245.63, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },

      { key: :audio_theme_is_ds4712,              name: "昼下がり気分",                          source_url: "https://dova-s.jp/bgm/play4712.html",            author: "KK",                   audio_part_a: :ds4712,              audio_part_a_volume: 1.0, audio_part_a_duration: 235.26, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "作者の紹介でYoutube動画に適しているとある", },
      { key: :audio_theme_is_nc35943,             name: "昼下がり",                              source_url: "https://commons.nicovideo.jp/material/nc35943",  author: "369(みろく)",          audio_part_a: :nc35943,             audio_part_a_volume: 1.0, audio_part_a_duration:  83.54, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_nc105702,            name: "ぐだぐだな感じ",                        source_url: "https://commons.nicovideo.jp/material/nc105702", author: "yuki",                 audio_part_a: :nc105702,            audio_part_a_volume: 1.0, audio_part_a_duration:  94.15, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_nc3366,              name: "はてな",                                source_url: "https://commons.nicovideo.jp/material/nc3366",   author: "しましまP @shimakid",  audio_part_a: :nc3366,              audio_part_a_volume: 1.0, audio_part_a_duration:  54.81, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },

      { key: :audio_theme_is_nc770,               name: "優しい風",                              source_url: "https://commons.nicovideo.jp/material/nc770",    author: "McCoy",                audio_part_a: :nc770,               audio_part_a_volume: 1.0, audio_part_a_duration: 120.04, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_nc43122,             name: "夜間航海",                              source_url: "https://commons.nicovideo.jp/material/nc43122",  author: "McCoy",                audio_part_a: :nc43122,             audio_part_a_volume: 1.0, audio_part_a_duration: 277.14, audio_part_a_loop: false, audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },
      { key: :audio_theme_is_ds12450,             name: "Somehow (Prod. Khaim)",                 source_url: "https://dova-s.jp/bgm/play12450.html",           author: "Khaim",                audio_part_a: :ds12450,             audio_part_a_volume: 1.0, audio_part_a_duration: 203.34, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_ds13037,             name: "YouTube向けラグタイム",                 source_url: "https://dova-s.jp/bgm/play13037.html",           author: "天休ひさし",           audio_part_a: :ds13037,             audio_part_a_volume: 1.0, audio_part_a_duration:  96.02, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },

      { key: :audio_theme_is_ds4000,              name: "Space Town (Brand New Mix)",            source_url: "https://dova-s.jp/bgm/play4000.html",            author: "Khaim",                audio_part_a: :ds4000,              audio_part_a_volume: 1.0, audio_part_a_duration:  96.05, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_nc107860,            name: "Shall we meet ?",                       source_url: "https://commons.nicovideo.jp/material/nc107860", author: "MATSU",                audio_part_a: :nc107860,            audio_part_a_volume: 1.0, audio_part_a_duration:  69.85, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },

      { key: :audio_theme_is_ds7615,              name: "Winner",                                source_url: "https://dova-s.jp/bgm/play7615.html",            author: "FLASH☆BEAT",          audio_part_a: :ds7615,              audio_part_a_volume: 1.0, audio_part_a_duration: 120.16, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_nc55257,             name: "3分クッキング (break beats)",           source_url: "https://commons.nicovideo.jp/material/nc55257",  author: "ジェルバ",             audio_part_a: :nc55257,             audio_part_a_volume: 1.0, audio_part_a_duration: 144.59, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "",                                          },

      { key: :audio_theme_is_ds5837,              name: "Taiko Warrior",                         source_url: "https://dova-s.jp/bgm/play5837.html",            author: "MFP",                  audio_part_a: :ds5837,              audio_part_a_volume: 1.0, audio_part_a_duration: 123.69, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_nc176917,            name: "Neu Kabuki",                            source_url: "https://commons.nicovideo.jp/material/nc176917", author: "MFP",                  audio_part_a: :nc176917,            audio_part_a_volume: 1.0, audio_part_a_duration: 134.45, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_ds5616,              name: "漢祭り",                                source_url: "https://dova-s.jp/bgm/play5616.html",            author: "山口 壮",              audio_part_a: :ds5616,              audio_part_a_volume: 1.0, audio_part_a_duration: 113.59, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_nc142538,            name: "武蔵",                                  source_url: "https://commons.nicovideo.jp/material/nc142538", author: "yuki",                 audio_part_a: :nc142538,            audio_part_a_volume: 1.0, audio_part_a_duration:  95.66, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_shw_akatsuki_japan,  name: "Akatsuki JAPAN",                        source_url: "http://shw.in/",                                 author: "SHW",                  audio_part_a: :shw_akatsuki_japan,  audio_part_a_volume: 1.0, audio_part_a_duration: 236.64, audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },
      { key: :audio_theme_is_ds3895,              name: "百花繚乱",                              source_url: "https://dova-s.jp/bgm/play3895.html",            author: "天休ひさし",           audio_part_a: :ds3895,              audio_part_a_volume: 1.0, audio_part_a_duration: 133.7,  audio_part_a_loop: true,  audio_part_b: nil,                   audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop",                                      },

      { key: :audio_theme_is_ds1245,              name: "流幻",                                  source_url: "https://dova-s.jp/bgm/play1245.html",            author: "かずち",               audio_part_a: :ds1245,              audio_part_a_volume: 1.0, audio_part_a_duration: 96.05,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds2776,              name: "井の中の蛙",                            source_url: "https://dova-s.jp/bgm/play2776.html",            author: "スエノブ",             audio_part_a: :ds2776,              audio_part_a_volume: 1.0, audio_part_a_duration: 35.16,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds7138,              name: "パーティーはハチャメチャ大騒ぎ",        source_url: "https://dova-s.jp/bgm/play7138.html",            author: "スエノブ",             audio_part_a: :ds7138,              audio_part_a_volume: 1.0, audio_part_a_duration: 36.05,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds3812,              name: "Three Keys (Freestyle Rap Beat No.02)", source_url: "https://dova-s.jp/bgm/play3812.html",            author: "Khaim",                audio_part_a: :ds3812,              audio_part_a_volume: 1.0, audio_part_a_duration: 237.72, audio_part_a_loop: false,  audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds14226,             name: "Somebody (Prod. Khaim)",                source_url: "https://dova-s.jp/bgm/play14226.html",           author: "Khaim",                audio_part_a: :ds14226,             audio_part_a_volume: 1.0, audio_part_a_duration: 158.17, audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds3480,              name: "ロデオ牧場",                            source_url: "https://dova-s.jp/bgm/play3480.html",            author: "かずち",               audio_part_a: :ds3480,              audio_part_a_volume: 1.0, audio_part_a_duration: 55.44,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds11184,             name: "Gliese (Prod. Khaim)",                  source_url: "https://dova-s.jp/bgm/play11184.html",           author: "Khaim",                audio_part_a: :ds11184,             audio_part_a_volume: 1.0, audio_part_a_duration: 157.13, audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds6719,              name: "Hero",                                  source_url: "https://dova-s.jp/bgm/play6719.html",            author: "Low",                  audio_part_a: :ds6719,              audio_part_a_volume: 1.0, audio_part_a_duration: 158.17, audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds11459,             name: "Dead End Strike",                       source_url: "https://dova-s.jp/bgm/play11459.html",           author: "ISAo",                 audio_part_a: :ds11459,             audio_part_a_volume: 1.0, audio_part_a_duration: 122.42, audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds11293,             name: "Jinrai Houto Rambu",                    source_url: "https://dova-s.jp/bgm/play11293.html",           author: "ISAo",                 audio_part_a: :ds11293,             audio_part_a_volume: 1.0, audio_part_a_duration: 49.29,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds6574,              name: "Stay On Your Mind",                     source_url: "https://dova-s.jp/bgm/play6574.html",            author: "Khaim",                audio_part_a: :ds6574,              audio_part_a_volume: 1.0, audio_part_a_duration: 174.6,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_ds3479,              name: "Blue Ever",                             source_url: "https://dova-s.jp/bgm/play3479.html",            author: "Khaim",                audio_part_a: :ds3479,              audio_part_a_volume: 1.0, audio_part_a_duration: 56.03,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: nil, },
      { key: :audio_theme_is_shw_tsudzumi_japan3, name: "Tsudzumi JAPAN 3",                      source_url: "http://shw.in/",                                 author: "SHW",                  audio_part_a: :shw_tsudzumi_japan3, audio_part_a_volume: 1.0, audio_part_a_duration: 293.49, audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: "loop", },
      { key: :audio_theme_is_nc145888,            name: "龍神 -Ryujin-",                         source_url: "https://commons.nicovideo.jp/material/nc145888", author: "謝謝P/魔界Symphony",   audio_part_a: :nc145888,            audio_part_a_volume: 1.0, audio_part_a_duration: 128.0,  audio_part_a_loop: true,   audio_part_b: nil,  audio_part_b_volume: nil, acrossfade_duration: nil, desc: "2:08 でカットする必要あり", },
    ]

    def to_params
      {
        :audio_part_a        => audio_part_a,
        :audio_part_a_volume => audio_part_a_volume,
        :audio_part_b        => audio_part_b,
        :audio_part_b_volume => audio_part_b_volume,
        :acrossfade_duration => acrossfade_duration,
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
    # |                audio_theme_is_none |        |
    # |       audio_theme_is_headspin_only | 28.05  |
    # |      audio_theme_is_breakbeat_only | 35.55  |
    # |         audio_theme_is_dance_chain | 28.05  |
    # |             audio_theme_is_nc97718 | 24.0   |
    # |               audio_theme_is_nc768 | 245.63 |
    # |              audio_theme_is_ds4712 | 235.26 |
    # |             audio_theme_is_nc35943 | 83.54  |
    # |            audio_theme_is_nc105702 | 94.15  |
    # |              audio_theme_is_nc3366 | 54.81  |
    # |               audio_theme_is_nc770 | 120.04 |
    # |             audio_theme_is_nc43122 | 277.14 |
    # |             audio_theme_is_ds12450 | 203.34 |
    # |             audio_theme_is_ds13037 | 96.02  |
    # |              audio_theme_is_ds4000 | 96.05  |
    # |            audio_theme_is_nc107860 | 69.85  |
    # |              audio_theme_is_ds7615 | 120.16 |
    # |             audio_theme_is_nc55257 | 144.59 |
    # |              audio_theme_is_ds5837 | 123.69 |
    # |            audio_theme_is_nc176917 | 134.45 |
    # |              audio_theme_is_ds5616 | 113.59 |
    # |            audio_theme_is_nc142538 | 95.66  |
    # |  audio_theme_is_shw_akatsuki_japan | 236.64 |
    # |              audio_theme_is_ds3895 | 133.7  |
    # |              audio_theme_is_ds1245 | 96.05  |
    # |              audio_theme_is_ds2776 | 35.16  |
    # |              audio_theme_is_ds7138 | 36.05  |
    # |              audio_theme_is_ds3812 | 237.72 |
    # |             audio_theme_is_ds14226 | 158.17 |
    # |              audio_theme_is_ds3480 | 55.44  |
    # |             audio_theme_is_ds11184 | 157.13 |
    # |              audio_theme_is_ds6719 | 158.17 |
    # |             audio_theme_is_ds11459 | 122.42 |
    # |             audio_theme_is_ds11293 | 49.29  |
    # |              audio_theme_is_ds6574 | 174.6  |
    # |              audio_theme_is_ds3479 | 56.03  |
    # | audio_theme_is_shw_tsudzumi_japan3 | 293.49 |
    # |            audio_theme_is_nc145888 | 128.0  |
    # |---------------------------------+--------|
    def native_duration
      if audio_part_a
        Media.duration(audio_part_a)
      end
    end

    private

    def real_path(basename)
      if basename
        "#{__dir__}/assets/audios/#{basename}.m4a"
      end
    end
  end
end
