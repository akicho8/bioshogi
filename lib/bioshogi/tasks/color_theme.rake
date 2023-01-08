namespace :color_theme do
  desc "配色テーマのキャッシュ生成"
  task "cache_build" do
    require "bioshogi"
    Bioshogi::ScreenImage::ColorThemeInfo.each do |e|
      e.color_theme_cache_build(verbose: true)
    end
  end
end
