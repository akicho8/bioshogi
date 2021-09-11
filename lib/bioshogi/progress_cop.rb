# frozen-string-literal: true
#
# 進捗通知
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
    attr_reader :timestamp
    attr_reader :total
    attr_reader :step
    attr_reader :message

    def initialize(total = 100, params = {}, &callback)
      @total = total

      @params = {
        throttle_interval: 1,  # trigger? は最低N秒間隔とする。指定したからといって callback の間隔が変わるわけではない
      }.merge(params)

      @callback = callback

      @step = 0
      @message = nil

      @timestamp = nil
      @last_triggered = nil
    end

    def next_step(message = nil)
      next_jump(1, message)
    end

    def next_jump(step_value, message = nil)
      @timestamp = Time.now
      @message = message
      @step += step_value
      if interval_passed?
        @trigger = true
        @last_triggered = @timestamp
      else
        @trigger = false
      end
      Bioshogi.logger&.debug { log }
      if @callback
        @callback.call(self)
      end
    end

    def trigger?                # TODO: 名前がいまいち。「ユーザーに見せるタイミングになっている」の意
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
        @timestamp.strftime("%F %T"),
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

    def to_h
      {
        :timestamp => timestamp,
        :total   => total,
        :step    => step,
        :percent => percent,
        :message => message,
        :log     => log,
      }
    end

    private

    # 一定期間経過したか？
    def interval_passed?
      unless @last_triggered
        return true
      end
      if v = @params[:throttle_interval]
        (@timestamp - @last_triggered) >= v
      end
    end
  end
end
