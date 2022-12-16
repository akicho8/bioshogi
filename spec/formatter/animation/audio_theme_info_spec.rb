require "spec_helper"

module Bioshogi
  module Formatter
    module Animation
      describe AudioThemeInfo do
        it "works" do
          AudioThemeInfo.each do |e|
            assert { e.valid? }
          end
        end
      end
    end
  end
end
