# frozen-string-literal: true
#
# 進捗
#
#   progress_cop = ProgressCop.new(5) { |e| puts e }
#   progress_cop.next_step("message1")
#   progress_cop.next_step("message2")
#   progress_cop.next_step("message3")
#
#   >> 2021-09-11 11:20:33 1/5  12.50 % T1 message1
#   >> 2021-09-11 11:20:33 2/5  25.00 % T0 message2 <-- 1秒経過していない
#   >> 2021-09-11 11:20:34 3/5  37.50 % T1 message3 <-- 1秒経過したので通知するべき
#
module Bioshogi
  class ProgressCop
    attr_reader :total
    attr_reader :step
    attr_reader :message

    def initialize(total = 100, params = {}, &callback)
      @total = total

      @params = {
        throttle_interval: 1,  # trigger? は最低N秒間隔とする
      }.merge(params)

      @callback = callback

      @step = 0
      @message = nil
      @last_triggered = Time.now - @params[:throttle_interval] # 初回の trigger? を発生させるため
    end

    def next_step(message = nil)
      @message = message
      @step += 1
      if interval_passed?
        @trigger = true
        @last_triggered = Time.now
      else
        @trigger = false
      end
      if @callback
        @callback.call(self)
      end
    end

    def trigger?
      @trigger
    end

    def percent
      to_f * 100
    end

    def to_f
      @step.fdiv(@total)
    end

    def to_s
      [
        Time.now.strftime("%F %T"),
        "#{@step}/#{@total}",
        "%6.2f %%" % percent,
        "T%d" % (@trigger ? 1 : 0),
        "#{message}"
      ].join(" ").strip
    end

    def log
      to_s
    end

    def inspect
      to_s
    end

    private

    def interval_passed?
      if v = @params[:throttle_interval]
        (Time.now - @last_triggered) >= v
      end
    end
  end
end
