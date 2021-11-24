require "spec_helper"

module AnimationSupport
  extend ActiveSupport::Concern

  included do
    after do
      FileUtils.rm_f(Dir["_outout*"])
    end
  end

  # カバー1p + 初期配置1p + 2手 + 終局図2p = 6p
  # 6ページ  * 1ページあたり0.5 = トータル3秒
  def target1(ext_name, method, params = {})
    info = Bioshogi:: Parser.parse("position startpos moves 7g7f 8c8d")
    bin = info.send(method, cover_text: "(cover_text)", bottom_text: "(bottom_text)", page_duration: 0.5, end_duration: 1, width: 2, height: 2, audio_theme_key: "is_audio_theme_ds3479", turn_embed_key: "is_turn_embed_on", **params)
    filename = Pathname("_outout.#{ext_name}")
    filename.write(bin)
    Bioshogi::Media.streams(filename).tap do |e|
      pp e if $0 == "-"
    end
  end
end
