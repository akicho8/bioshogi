require "spec_helper"

module Bioshogi
  describe SystemSupport do
    it "works" do
      expect { Bioshogi::SystemSupport.strict_system("exit 1") }.to raise_error(StandardError)
    end
  end
end
