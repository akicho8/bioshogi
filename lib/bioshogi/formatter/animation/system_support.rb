require "shellwords"
require "timeout"
require "systemu"

module Bioshogi
  module Formatter
    module Animation
      module SystemSupport
        extend self

        FFMPEG_CURRENT_VERSION_REQUIRED_GTEQ = "4.4"

        delegate :logger, to: "Bioshogi"

        def strict_system(command)
          logger.tagged("execute") do
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
          logger.info { "which #{command}" }
          status, _, _ = systemu("which #{command}")
          logger.info { "status: #{status}" }
          if !status.success?
            raise StandardError, "no #{command} in path"
          end
        end

        def ffmpeg_version_required!(need = FFMPEG_CURRENT_VERSION_REQUIRED_GTEQ)
          if current = ffmpeg_current_version
            need = Gem::Version.new(need)
            if current < need
              raise FfmpegError, "ffmpeg requires version #{need} or later, but provides version #{current}"
            end
          end
        end

        def ffmpeg_current_version
          command = "ffmpeg -version | head -1"
          logger.info { command }
          s = `#{command}`
          logger.info { s }
          if md = s.match(/version\s+(\S+)/i)
            Gem::Version.create(md.captures.first)
          end
        end
      end
    end
  end
end
