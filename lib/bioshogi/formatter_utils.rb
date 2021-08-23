module Bioshogi
  module FormatterUtils
    delegate :logger, to: "Bioshogi"

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

    def mp4_factory_key
      params.fetch(:mp4_factory_key).to_s
    end

    def one_frame_duration
      params[:one_frame_duration].to_f
    end
  end
end
