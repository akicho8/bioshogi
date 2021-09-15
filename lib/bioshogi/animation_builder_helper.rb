require "shellwords"
require "timeout"

module Bioshogi
  concern :AnimationBuilderHelper do
    included do
      cattr_accessor(:one_second) { 10000 } # ffmpeg の -r x/y の x の部分
    end

    class_methods do
      def default_params
        {
          # 全体
          :one_frame_duration_sec     => 1.0,  # 1手N秒 10000/60 = 166.666666667 なので 0.0166666666667 を指定すると 60 FPS になる
          :end_duration_sec           => 0,    # 終了図をN秒表示する
          :end_frames                 => nil,  # 終了図追加フレーム数。空なら end_duration_sec / one_frame_duration_sec
          :progress_callback          => nil,  # 進捗通知用
          :cover_text                 => nil,  # 表紙(nilなら作らない)

          # 他
          :ffmpeg_after_embed_options => nil,      # ffmpegコマンドの YUV420 変換の際に最後に埋めるコマンド(-crt )
          :tmpdir_remove              => true,     # 作業ディレクトリを最後に削除するか？ (デバッグ時にはfalseにする)
          :media_factory_key          => "ffmpeg", # rmagick or ffmpeg
          :continuous_render          => true,     # canvasを一度作成したらそのコピーを使い回す(昔はそうだった)
        }
      end
    end

    delegate :logger, to: "Bioshogi"

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

    def media_factory_key
      params.fetch(:media_factory_key).to_s
    end

    def one_frame_duration_sec
      params[:one_frame_duration_sec].to_f
    end

    def ffmpeg_after_embed_options
      if v = params[:ffmpeg_after_embed_options].presence
        Shellwords.join(Shellwords.split(v))
      end
    end

    # 最後の局面を追加で足す回数
    # これを設定しても最終的な秒数は不明なため基本指定せず、指定した end_duration_sec から算出した方がよい
    # |------------------+------------------------+-----------+-----+----------------|
    # |   伸ばしたい秒数 |                 1手N秒 |           |     | 追加フレーム数 |
    # | end_duration_sec | one_frame_duration_sec |           |     |     end_frames |
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
    def end_frames
      if v = params[:end_frames]
        v.to_i
      else
        params[:end_duration_sec].fdiv(one_frame_duration_sec).ceil
      end
    end

    # 1手 0.5 秒 → "-r 60/30"
    # 1手 1.0 秒 → "-r 60/60"
    # 1手 1.5 秒 → "-r 60/90"
    def fps_value
      v = (one_second * one_frame_duration_sec).to_f
      "#{one_second}/#{v}"
    end

    def strict_system(command)
      logger.tagged("execute") do
        require "systemu"
        t = Time.now
        logger.info { command }
        status, stdout, stderr = systemu(command) # 例外は出ないのでensure不要
        logger.info { "status: #{status}" } if !status.success?
        logger.info { "elapsed: #{(Time.now - t).round}s" }
        logger.info { "stderr: #{stderr}" } if stderr.present?
        logger.info { "stdout: #{stdout}" } if stdout.present?
        if !status.success?
          raise StandardError, stderr.strip
        end
      end
    end

    def command_required!(command)
      require "systemu"
      status, _, _ = systemu("which #{command}")
      if !status.success?
        raise StandardError, "no #{command} in path"
      end
    end

    def number_file
      "_input%04d.png"
    end
  end
end
