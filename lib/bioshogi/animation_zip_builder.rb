module Bioshogi
  class AnimationZipBuilder
    cattr_accessor :default_params do
      {
        basename_format: "%04d",
        continuous_build: true, # 連続で処理する
      }
    end

    attr_reader :params

    delegate :logger, to: "Bioshogi"

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
    end

    def to_binary
      require "zip"
      mediator = @parser.mediator_for_image
      @image_renderer = ImageRenderer.new(mediator, params)
      dos_time = Zip::DOSTime.from_time(Time.now)
      zos = Zip::OutputStream.write_buffer do |z|
        zip_write(z, dos_time, 0)
        @parser.move_infos.each.with_index(1) do |e, i|
          mediator.execute(e[:input])
          zip_write(z, dos_time, i)
        end
      end
      @image_renderer.layer_destroy_all
      zos.string
    end

    private

    def filename_for(index)
      (params[:basename_format] % index) + ".png"
    end

    def zip_write(z, dos_time, index)
      entry = Zip::Entry.new(z, filename_for(index))
      entry.time = dos_time
      z.put_next_entry(entry)
      z.write(@image_renderer.to_blob_binary)
      logger.info { "move: #{index} / #{@parser.move_infos.size}" } if index.modulo(10).zero?
    end
  end
end
