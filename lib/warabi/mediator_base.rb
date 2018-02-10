# frozen-string-literal: true

module Warabi
  concern :MediatorBase do
    def mediator_options
      @mediator_options ||= {
        skill_set_flag: false,
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
