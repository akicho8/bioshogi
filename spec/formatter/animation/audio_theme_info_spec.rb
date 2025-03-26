require "spec_helper"

RSpec.describe Bioshogi::Formatter::Animation::AudioThemeInfo do
  it "works" do
    Bioshogi::Formatter::Animation::AudioThemeInfo.each do |e|
      assert { e.valid? }
    end
  end
end
