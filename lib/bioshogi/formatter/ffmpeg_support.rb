module Bioshogi
  module Formatter
    class FfmpegError < StandardError; end

    concern :FfmpegSupport do
      include SystemSupport

      included do
        cattr_accessor(:one_second) { 10000 } # ffmpeg の -r x/y の x の部分
      end

      class_methods do
        def default_params
          super.merge({
              # 全体
              :page_duration              => 1.0,    # 1手N秒 10000/60 = 166.666666667 なので 0.0166666666667 を指定すると 60 FPS になる
              :end_duration               => 0,      # 終了図をN秒表示する
              :end_pages                  => nil,    # 終了図追加フレーム数。空なら end_duration / page_duration
              :progress_callback          => nil,    # 進捗通知用
              :cover_text                 => nil,    # 表紙(nilなら作らない)
              :bottom_text                => nil,    # 表紙の右下に小さく表示する1行
              :turn_embed_key             => "is_turn_embed_off", # 手数を埋め込むか？

              # 他
              :ffmpeg_after_embed_options => nil,                        # ffmpegコマンドの YUV420 変換の際に最後に埋めるコマンド(-crt )
              :tmpdir_remove              => true,                       # 作業ディレクトリを最後に削除するか？ (デバッグ時にはfalseにする)
              :factory_method_key         => "is_factory_method_ffmpeg", # is_factory_method_rmagick or is_factory_method_ffmpeg
            })
        end
      end

      attr_reader :params

      private

      def in_work_directory
        begin
          require "rmagick"
          dir = Dir.mktmpdir
          logger.info { "cd #{dir}" }
          Dir.chdir(dir) do
            yield
          end
        ensure
          if params[:tmpdir_remove]
            logger.info { "rm -fr #{dir}" }
            FileUtils.remove_entry_secure(dir)
          end
        end
      end

      def factory_method_key
        params.fetch(:factory_method_key).to_s
      end

      def page_duration
        params[:page_duration].to_f
      end

      def ffmpeg_after_embed_options
        if v = params[:ffmpeg_after_embed_options].presence
          Shellwords.join(Shellwords.split(v))
        end
      end

      # 最後の局面を追加で足す回数
      # これを設定しても最終的な秒数は不明なため基本指定せず、指定した end_duration から算出した方がよい
      # |------------------+------------------------+-----------+-----+----------------|
      # |   伸ばしたい秒数 |                 1手N秒 |           |     | 追加フレーム数 |
      # | end_duration | page_duration |           |     |     end_pages |
      # |------------------+------------------------+-----------+-----+----------------|
      # |              2.0 |                    0.4 | 2.0 / 0.4 | 5.0 |              5 |
      # |              2.0 |                    0.5 | 2.0 / 0.5 | 4.0 |              4 |
      # |              2.0 |                    0.6 | 2.0 / 0.6 | 3.3 |              4 |
      # |              2.0 |                    0.9 | 2.0 / 0.9 | 2.2 |              3 |
      # |              2.0 |                    1.0 | 2.0 / 1.0 | 2.0 |              2 |
      # |              2.0 |                    1.1 | 2.0 / 1.1 | 1.8 |              2 |
      # |              2.0 |                    2.0 | 2.0 / 2.0 | 1.0 |              1 |
      # |              2.0 |                    3.0 | 2.0 / 3.0 | 0.6 |              1 |
      # |              2.0 |                    4.0 | 2.0 / 4.0 | 0.5 |              1 |
      # |              0.1 |                    1.0 | 0.1 / 1.0 | 0.1 |              1 |
      # |              0.0 |                    1.0 | 0.0 / 1.0 | 0.0 |              0 |
      # |              0.0 |                    0.0 | 0.0 / 0.0 | ERR |                |
      # |------------------+------------------------+-----------+-----+----------------|
      # 伸ばしたい秒数分だけ手が必要なので「伸ばす秒数/1手秒数」で追加フレーム数がわかる
      # ただ1手の秒数より伸ばす秒数が少ないと繰り上げる必要がある
      def end_pages
        if v = params[:end_pages]
          v.to_i
        else
          params[:end_duration].fdiv(page_duration).ceil
        end
      end

      # 1手 0.5 秒 → "-r 60/30"
      # 1手 1.0 秒 → "-r 60/60"
      # 1手 1.5 秒 → "-r 60/90"
      def fps_value
        v = (one_second * page_duration).to_f
        "#{one_second}/#{v}"
      end

      def sfg
        @sfg ||= SerialFilenameGenerator.new
      end
    end
  end
end
