require "spec_helper"

module Bioshogi
  RSpec.describe ApplicationMemoryRecord do
    it "works" do
      klass = Class.new do
        include ApplicationMemoryRecord
        memory_record []
      end
      expect { klass.fetch(:foo) }.to raise_error(KeyNotFound)
    end
  end
end
