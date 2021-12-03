module Bioshogi
  class CoverRenderer
    include ImageRenderer::Helper
  end

  require "bioshogi/cover_renderer/base"
  require "bioshogi/cover_renderer/main_text_methods"
  require "bioshogi/cover_renderer/bottom_text_methods"
end
