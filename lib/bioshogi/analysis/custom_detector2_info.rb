module Bioshogi
  module Analysis
    class CustomDetector2Info
      include ApplicationMemoryRecord
      memory_record [
        {
          key: "王手飛車判定",
          trigger: { piece_key: :bishop, promoted: :both, motion: :both },
          klass: CustomDetectors::OutebishaDetector,
        },
        {
          key: "王手角判定",
          trigger: { piece_key: :root, promoted: :both, motion: :both },
          klass: CustomDetectors::OutekakuDetector,
        },
        {
          key: "技ありの桂判定",
          trigger: { piece_key: :knight, promoted: true, motion: :move },
          klass: CustomDetectors::WazaarinokeiDetector,
        },
      ]
    end
  end
end
