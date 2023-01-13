module Bioshogi
  module Formatter
    module Animation
      class AnimationZipBuilder
        include Builder
        include AnimationBuilderTimeout

        def self.default_params
          super.merge({
              :basename_format   => "%04d",
              :progress_callback => nil,  # 進捗通知用
              :cover_text        => nil,  # 表紙の内容(あれば表紙画像を作る)
              :bottom_text       => nil,  # 表紙の右下に小さく表示する1行
            })
        end

        attr_reader :params

        delegate :logger, to: "Bioshogi"

        def initialize(formatter, params = {})
          require "zip"
          @formatter = formatter
          @params = self.class.default_params.merge(params)
        end

        def to_binary
          container = @formatter.container_for_image
          @screen_image_renderer = ScreenImage.renderer(container, params)
          @progress_cop = ProgressCop.new(1 + 1 + @formatter.pi.move_infos.size, &params[:progress_callback])
          zos = Zip::OutputStream.write_buffer do |z|
            if v = params[:cover_text].presence
              @progress_cop.next_step("表紙描画")
              tob("表紙描画") { zip_write2(z, "cover.png", CoverImage.renderer(text: v, **params.slice(:bottom_text, :width, :height)).to_png24_binary) }
            end
            @progress_cop.next_step("初期配置")
            tob("初期配置") { zip_write1(z, 0) }
            @formatter.pi.move_infos.each.with_index do |e, i|
              @progress_cop.next_step("(#{i}/#{@formatter.pi.move_infos.size}) #{e[:input]}")
              container.execute(e[:input])
              tob("#{i}/#{@formatter.pi.move_infos.size}") { zip_write1(z, i.next) }
              logger.info { "move: #{i} / #{@formatter.pi.move_infos.size}" } if i.modulo(10).zero?
            end
          end
          @screen_image_renderer.clear_all
          zos.string
        end

        private

        def filename_for(index)
          (params[:basename_format] % index) + ".png"
        end

        def zip_write1(z, index)
          zip_write2(z, filename_for(index), @screen_image_renderer.to_png24_binary)
        end

        def zip_write2(z, filename, bin)
          entry = Zip::Entry.new(z, filename)
          entry.time = fixed_entry_time
          z.put_next_entry(entry)
          z.write(bin)
        end

        def fixed_entry_time
          @fixed_entry_time ||= Zip::DOSTime.from_time(Time.now)
        end
      end
    end
  end
end
