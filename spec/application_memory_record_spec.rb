require_relative "spec_helper"

module Bushido
  describe ApplicationMemoryRecord do
    it do
      klass = Class.new do
        include ApplicationMemoryRecord
        memory_record []
      end
      expect { klass.fetch(:foo) }.to raise_error(KeyNotFound)
    end
  end
end
