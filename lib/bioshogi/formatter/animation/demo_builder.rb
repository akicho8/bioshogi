# BGMが合っているか確認するのが目的
# 別になくてもよい

module Bioshogi
  module Formatter
    module Animation
      class DemoBuilder
        def call
          Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
          no_audio_file_create_unless_file
          AudioThemeInfo.each(&method(:build_one))
        end

        private

        def build_one(e)
          if e.audio_part_a && e.audio_part_b.nil?
            name = ("%02d" % e.code) + "_" + e.name.gsub(/[?.()-]/, "_").gsub(/\P{Graph}+/, "_").gsub(/_+/, "_")
            output_file = store_dir.join("#{name}.mp4")
            system "ffmpeg -v warning -i #{no_audio_file} -i #{e.audio_part_a} -c copy -y #{output_file}"
            puts output_file
          end
        end

        def no_audio_file_create_unless_file
          unless no_audio_file.exist?
            no_audio_file_create
          end
        end

        def no_audio_file_create
          # info = Parser.parse("position sfen g1+P1k1+P+P+L/1p3P3/+R+p2pp1pl/1NNsg+p2+R/+b+nL+P1+p3/1P3ssP1/2P1+Ps2N/4+P1P1L/+B5G1g b - 1 moves 4b4a+ 5a5b 7d6b+ 5b6b 7a6a 6b5b 6a5a 5b6b 8d7b+ 6b6c 6e7d 6c7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b 1a2a 2b1b N*2d 2c2d 2a1a 1b2b 1d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 4d3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d P*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 1d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d L*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*3d 3c3d 7g7f 4e4d 3a2a 2b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d L*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b 1a2a 2b1b N*2d 2c2d 9i8i 4d4e 2a1a 1b2b 1d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d P*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 1d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d L*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*3d 3c3d 8i8h 4e4d 3a2a 2b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d L*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b 1a2a 2b1b N*2d 2c2d 8h7h 4d4e 2a1a 1b2b 1d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d P*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 1d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d L*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*3d 3c3d 7h7g 4e4d 3a2a 2b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d L*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b 1a2a 2b1b N*2d 2c2d 7g6g 4d4e 2a1a 1b2b 1d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d P*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 1d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d L*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*3d 3c3d 6g6f 4e4d 3a2a 2b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d L*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 3d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b L*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 1a2a 2b1b 2d1d L*1c 2a1a 1b2b 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b N*2d 2c2d 2a3a 3b2b 1d2d P*2c 3a2a 2b3b 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b N*3d 3c3d 3a4a 4b3b 2d3d P*3c 4a3a 3b4b 5a4a 4b5b 6a5a 5b6b P*6c 6b7b 7d8c 7b6c 8c8d N*8c 8d7d 6c6b 5a6a 6b5b 4a5a 5b4b 3a4a 4b3b 2a3a 3b2b N*1d 1c1d 9c8b 9a8b 1a2a 2b1b P*1c 1b1c 1g2e 3f2e 1h1d 2e1d 3d1d 1c1d L*1f 1d2d S*2e 2d3e 5g4f 3e2f 6f4h 4g4h 4f3f 2f1g S*2h 1g1h 2h1i 1h1i G*2i")
          # bin = info.to_animation_mp4(page_duration: 0.0166666666667, end_duration: 0)
          # no_audio_file.write(bin)

          file = Analysis::TacticInfo.flat_lookup("トマホーク").static_kif_file
          info = Parser.parse(file)
          bin = info.to_animation_mp4({
              :color_theme_key => :is_color_theme_real,
              :page_duration   => 0.5,
              :end_duration    => 7,
              :audio_part_a    => nil,
              :audio_part_b    => nil,
            })
          no_audio_file.write(bin)
        end

        def no_audio_file
          store_dir.join("no_audio.mp4")
        end

        def store_dir
          ROOT.join("../demo/BGM合成後の確認用").expand_path
        end
      end
    end
  end
end
