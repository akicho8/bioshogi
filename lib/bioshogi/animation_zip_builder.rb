module Bioshogi
  class AnimationZipBuilder
    include Builder
    include AnimationBuilderTimeout

    def self.default_params
      super.merge({
          :basename_format   => "%04d",
          :continuous_render => true, # 連続で処理する
          :progress_callback => nil,  # 進捗通知用
          :cover_text        => nil,  # 表紙の内容(あれば表紙画像を作る)
        })
    end

    attr_reader :params

    delegate :logger, to: "Bioshogi"

    def initialize(parser, params = {})
      require "zip"
      @parser = parser
      @params = self.class.default_params.merge(params)
    end

    def to_binary
      mediator = @parser.mediator_for_image
      @image_renderer = ImageRenderer.new(mediator, params)
      @progress_cop = ProgressCop.new(1 + 1 + @parser.move_infos.size, &params[:progress_callback])
      zos = Zip::OutputStream.write_buffer do |z|
        if v = params[:cover_text].presence
          @progress_cop.next_step("表紙描画")
          tob("表紙描画") { zip_write2(z, "cover.png", CoverRenderer.new(text: v, **params.slice(:width, :height)).to_png24_binary) }
        end
        @progress_cop.next_step("初期配置")
        tob("初期配置") { zip_write1(z, 0) }
        @parser.move_infos.each.with_index do |e, i|
          @progress_cop.next_step("(#{i}/#{@parser.move_infos.size}) #{e[:input]}")
          mediator.execute(e[:input])
          tob("#{i}/#{@parser.move_infos.size}") { zip_write1(z, i.next) }
          logger.info { "move: #{i} / #{@parser.move_infos.size}" } if i.modulo(10).zero?
        end
      end
      @image_renderer.clear_all
      zos.string
    end

    private

    def filename_for(index)
      (params[:basename_format] % index) + ".png"
    end

    def zip_write1(z, index)
      zip_write2(z, filename_for(index), @image_renderer.to_png24_binary)
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
