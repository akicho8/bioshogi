module Bioshogi
  module Analysis
    class TagReporter
      def call
        values = TagIndex.values.find_all(&:shape_info)
        write("shape_info", values)

        values = TagIndex.values.find_all(&:shape_detector)
        write("shape", values)

        values = TagIndex.values.find_all(&:motion_detector)
        write("motion", values)

        values = TagIndex.values.find_all(&:capture_detector)
        write("capture", values)

        values = TagIndex.values.find_all(&:every_detector)
        write("every", values)

        values = TagIndex.values
        write("all", values)
      end

      def attributes_of(e)
        { "種類" => e.human_name, **e.attributes }
      end

      def outdir
        Pathname(__dir__).join("report")
      end

      def write(name, values)
        rows = values.collect { |e| attributes_of(e) }
        file = outdir.join("#{name}.org")
        file.write(rows.to_t)
        puts "output: #{file}"
      end
    end
  end
end
