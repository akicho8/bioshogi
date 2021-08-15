module Bioshogi
  class AnimationZipFormatter
    cattr_accessor :default_params do
      {
        basename_format: "%04d",
      }
    end

    attr_accessor :parser
    attr_accessor :params

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
    end

    def to_binary
      require "zip"
      mediator = mediator_setup
      f = ImageFormatter.new(mediator, params.merge(image_format: "png"))
      dos_time = Zip::DOSTime.from_time(Time.now)
      zos = Zip::OutputStream.write_buffer do |z|
        zip_write(z, f, dos_time, 0)
        parser.move_infos.each.with_index(1) do |e, i|
          mediator.execute(e[:input])
          zip_write(z, f, dos_time, i)
        end
      end
      zos.string
    end

    private

    # TODO
    def mediator_setup
      mediator = Mediator.new
      mediator.params.update({
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
          :candidate_enable               => false,
          :validate_enable                => false,
        })
      parser.mediator_board_setup(mediator)
      mediator
    end

    def filename_for(index)
      (params[:basename_format] % index) + ".png"
    end

    def zip_write(z, f, dos_time, index)
      entry = Zip::Entry.new(z, filename_for(index))
      entry.time = dos_time
      z.put_next_entry(entry)
      f.render
      z.write(f.to_blob_binary)
    end
  end
end
