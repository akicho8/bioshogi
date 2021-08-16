module Bioshogi
  class AnimationGifFormatter
    cattr_accessor :default_params do
      {
        :end_frames  => 0,                  # 終了図だけ指定フレーム数停止
        :video_speed => 1.0,                # 1手N秒
        :loop_key    => "is_loop_infinite", # ループモード
      }
    end

    attr_accessor :parser
    attr_accessor :params

    def initialize(parser, params = {})
      @parser = parser
      @params = default_params.merge(params)
    end

    def to_binary
      require "rmagick"

      mediator = parser.mediator_for_image
      image_formatter = ImageFormatter.new(mediator, params)
      @list = Magick::ImageList.new
      image_formatter.render
      @list.concat([image_formatter.canvas])
      parser.move_infos.each do |e|
        mediator.execute(e[:input])
        image_formatter.render
        @list.concat([image_formatter.canvas]) # canvas は Magick::Image のインスタンス
      end
      @list.concat([image_formatter.canvas] * params[:end_frames])
      @list.delay = @list.ticks_per_second * video_speed
      # if params[:optimize_layer]

      # 46s 5.5M optimize_layers なし
      # 43s 544K optimize_layers あり
      @list = @list.optimize_layers(Magick::OptimizeLayer) # 各ページを最小枠にする (重要)
      # end
      @list.iterations = iterations_number  # 繰り返し回数

      Tempfile.create(["", ".#{ext_name}"]) do |t|
        @list.write(t.path)
        @list.destroy!
        File.read(t.path)
      end
    end

    private

    def ext_name
      "gif"
    end

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
    def iterations_number
      if params[:loop_key] == "is_loop_infinite"
        0
      else
        1
      end
    end

    def video_speed
      params[:video_speed]
    end
  end
end
