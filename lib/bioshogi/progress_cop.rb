# frozen-string-literal: true
#
# 進捗
#
#   progress_cop = ProgressCop.new(5) { |e| puts e[:log] }
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
    def initialize(total = 100, params = {}, &callback)
      @total = total

      @params = {
        throttle_interval: 1,  # trigger? は最低N秒間隔とする
      }.merge(params)

      @callback = callback

      @step = 0
      @last_triggered = Time.now - @params[:throttle_interval] # 初回の trigger? を発生させるため
    end

    def next_step(message = nil)
      @step += 1
      if some_time_passed?
        @trigger = true
        @last_triggered = Time.now
      else
        @trigger = false
      end
      if @callback
        @callback.call(info: self, log: "#{to_s} #{message}".strip)
      end
    end

    def trigger?
      @trigger
    end

    def progress_rate
      to_f * 100
    end

    def to_f
      @step.fdiv(@total)
    end

    def to_s
      [
        Time.now.strftime("%F %T"),
        "#{@step}/#{@total}",
        "%6.2f %%" % progress_rate,
        "T%d" % (@trigger ? 1 : 0),
      ].join(" ")
    end

    def inspect
      to_s
    end

    private

    def some_time_passed?
      if v = @params[:throttle_interval]
        (Time.now - @last_triggered) >= v
      end
    end
  end
end
