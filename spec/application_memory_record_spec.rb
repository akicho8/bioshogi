require "spec_helper"

RSpec.describe Bioshogi::ApplicationMemoryRecord do
  it "works" do
    klass = Class.new do
      include Bioshogi::ApplicationMemoryRecord
      memory_record []
    end
    expect { klass.fetch(:foo) }.to raise_error(Bioshogi::KeyNotFound)
  end
end
