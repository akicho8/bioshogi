# frozen-string-literal: true

module Warabi
  concern :MediatorBase do
    def params
      @params ||= {
        skill_monitor_enable: false,
      }
    end

    def deep_dup
      Marshal.load(Marshal.dump(self))
    end

    def context_new(&block)
      yield deep_dup
    end

    def inspect
      to_s
    end
  end
end
