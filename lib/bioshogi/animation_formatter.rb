module Bioshogi
  class AnimationFormatter < BinaryFormatter
    cattr_accessor :default_params do
      {
        :delay_per_one    => 1.0,   # 1枚をN秒で表示する
        :animation_format => "gif", # 出力フォーマット
        :loop             => false, # ループするか？
      }
    end

    attr_accessor :parser
    attr_accessor :mediator
    attr_accessor :params
    attr_accessor :list
    attr_accessor :hand_log

    def initialize(parser, params = {})
      # params.assert_valid_keys(default_params.keys + ImageFormatter.default_params.keys)

      @parser = parser
      @params = default_params.merge(params)
    end

    def to_blob
      @list.format = animation_format
      @list.to_blob
    end

    def render
      require "rmagick"

      mediator = Mediator.new         # MediatorFast にしても45秒が44秒になる程度
      mediator.params.update({
          :skill_monitor_enable           => false,
          :skill_monitor_technique_enable => false,
          :candidate_enable               => false,
          :validate_enable                => false,
        })
      parser.mediator_board_setup(mediator) # FIXME: これ、必要ない SFEN を生成したりして遅い

      image_formatter = ImageFormatter.new(mediator, params.slice(ImageFormatter.default_params.keys))
      # puts mediator

      @list = Magick::ImageList.new
      # @list.ticks_per_second           # =>
      # @list.delay = @list.ticks_per_second
      # list.start_loop               # =>
      image_formatter.render
      @list.concat([image_formatter.canvas])
      parser.move_infos.each.with_index(1) do |e, i|
        mediator.execute(e[:input])
        image_formatter.render
        @list.concat([image_formatter.canvas]) # canvas は Magick::Image のインスタンス
        # puts image_formatter.write_to_tempfile
        # image_formatter.canvas.write("#{i}.gif")
      end
      @list.ticks_per_second           # => 100
      @list.delay = @list.ticks_per_second * params[:delay_per_one]

      @list = @list.coalesce            # これを外すと 45 が 41 になった
      @list = @list.optimize_layers(Magick::OptimizeLayer)
      @list.iterations = gif_iterations  # 繰り返し回数

      # @list.start_loop = false
      # @list.scene = 1

      # @list.to_blob[0..3]              # => "GIF8"
      # @list.write("out.gif")
      # @list.each.with_index do |e, i|
      #   e.write("#{i}.png")
      # end
      # puts @list.inspect # => nil

      # puts mediator
      # >> [0.png GIF 1200x630 1200x630+0+0 PseudoClass 33c 16-bit 25kb,
      # >> 1.png  68x135 1200x630+433+348 PseudoClass 33c 16-bit 1kb,
      # >> 2.png  42x109 1200x630+377+159 PseudoClass 34c 16-bit 1kb,
      # >> 3.png  42x109 1200x630+782+363 PseudoClass 34c 16-bit 1kb]
      # >> scene=0
    end

    private

    # 繰り返し回数
    #
    #  0: 無限ループ
    #  1: 1回
    #  2: 2回
    #
    # exiftool では "Animation Iterations" の項目でこの値がわかるが1ずれている
    # exiftool では「繰り返す回数」つまり「戻る回数」なので1なら戻らないので0で、なぜか0は表示されない
    # 0なら無限と表示され、2なら1回(戻る)と表示される
    #
    def gif_iterations
      if params[:loop]
        0
      else
        1
      end
    end

    def animation_format
      params[:animation_format] or raise ArgumentError, "params[:animation_format] is blank"
    end
  end
end
