module Bioshogi
  module Analysis
    class XmotionDetectorInfo
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "王手飛車判定",
          trigger: { piece_key: :bishop, promoted: :both, motion: :both },
          klass: XmotionDetectors::OutebishaDetector,
        },
        {
          key: "王手角判定",
          trigger: { piece_key: :rook, promoted: :both, motion: :both },
          klass: XmotionDetectors::OutekakuDetector,
        },
        {
          key: "技ありの桂判定",
          trigger: { piece_key: :knight, promoted: true, motion: :move },
          klass: XmotionDetectors::WazaarinokeiDetector,
        },
        {
          key: "双馬結界判定",
          trigger: { piece_key: :bishop, promoted: true, motion: :move },
          klass: XmotionDetectors::HorseDetector,
        },
        {
          key: "N段ロケット判定",
          trigger: [
            { piece_key: :rook,  promoted: :both, motion: :both },
            { piece_key: :lance, promoted: false, motion: :drop },
          ],
          klass: XmotionDetectors::RocketDetector,
        },
      ]

      class << self
        def trigger_table
          @trigger_table ||= each_with_object({}) do |e, m|
            e.triggers.each do |key|
              m[key] ||= []
              m[key] << e
            end
          end
        end
      end

      def triggers
        TriggerExpander.expand(trigger)
      end
    end
  end
end
