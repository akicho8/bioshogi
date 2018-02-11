# frozen-string-literal: true

module Warabi
  concern :MediatorVariables do
    attr_reader :variables
    attr_reader :var_stack

    def initialize(*)
      super

      @variables = {}
      @var_stack = Hash.new([])
    end

    def set(key, value)
      @variables[key] = value
    end

    def get(key)
      @variables[key]
    end

    def var_push(key)
      @var_stack[key] << @variables[key]
    end

    def var_pop(key)
      @variables[key] = @var_stack[key].pop
    end

    def to_text
      out = []
      out << "-" * 40 + " " + variables.inspect + "\n"
      out << "指し手: #{ki2_hand_logs.join(" ")}\n"
      out << to_kif
      out.join.strip
    end
  end
end
