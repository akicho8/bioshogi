#
# 棋譜の一手分の保存用
#
# FIXME: 後手から見るには point 関連をすべて反転させて調べた方がよさそう

module Bushido
  class HandLog
    attr_reader :point, :piece, :promoted, :promote_trigger, :strike_trigger, :origin_point, :player, :candidate, :point_same_p

    def initialize(attrs)
      # FIXME: こんなんやるんなら ActiveModel でいいんじゃね？
      attrs.each do |k, v|
        instance_variable_set("@#{k}", v)
      end

      raise MustNotHappen, "成駒を打った" if @strike_trigger && @promoted
      raise MustNotHappen, "打つと同時に成った" if @strike_trigger && @promote_trigger
      raise MustNotHappen, "成駒をさらに成った" if @promoted && @promote_trigger
    end

    # 両方返す
    # 主にテスト用
    def to_kif_ki2
      [to_s_kif, to_s_ki2]
    end

    def to_kif_ki2_csa
      [to_s_kif, to_s_ki2, to_s_csa]
    end

    # "７六歩" のようなCPUに優しいKIF形式の表記で返す
    def to_s_kif(**options)
      options = {
        with_mark: false,
      }.merge(options)

      s = []
      if options[:with_mark]
        s << @player.location.mark
      end
      s << @point.name
      s << @piece.some_name(@promoted)
      if @promote_trigger
        s << "成"
      end
      if @strike_trigger
        s << "打"
      end
      if @origin_point
        s << "(#{@origin_point.number_format})"
      end
      s.join
    end

    # "58金右" のような人間向けの表記を返す
    def to_s_ki2(**options)
      official_formatter(options).to_s
    end

    def official_formatter(**options)
      OfficialFormatter.new(self, options)
    end

    def to_s_csa(**options)
      s = ""
      s << @player.location.csa_sign
      if @origin_point
        s << @origin_point.number_format
      else
        s << "00"               # 駒台
      end
      s << @point.number_format
      s << @piece.csa_some_name(@promoted || @promote_trigger)
      s
    end

    def to_h
      [:point, :piece, :promoted, :promote_trigger, :strike_trigger, :origin_point, :player, :candidate, :point_same_p].inject({}) {|a, key| a.merge(key => send(key)) }
    end

    class OfficialFormatter
      attr_reader :hand_log
      attr_reader :options

      def initialize(hand_log, **options)
        @hand_log = hand_log
        @options = {
          with_mark: false,    # 先手後手のマークを入れる？
          strike_force: false, # 「打」を省略できるときでも「打」を明示する？
          same_suffix: "",     # 「同」の後に入れる文字列
          compact: true,       # 3文字を超えたらとき空白が含まれていれば詰める？
        }.merge(options)
      end

      def to_debug_hash
        {
          origin_point: @hand_log.origin_point,
          point: @hand_log.point,
          to_s: to_s,
          candidate: candidate.collect(&:name),
          koreru_c: koreru_c,
          _migi_idou: _migi_idou,
          _hidari_idou: _hidari_idou,
          _ue_idou: _ue_idou,
          _shita_idou: _shita_idou,
          _hidari_kara_c: _hidari_kara_c,
          _migi_kara_c: _migi_kara_c,
          yoreru_c: yoreru_c,
          agareru_c: agareru_c,
          sagareru_c: sagareru_c,
          shita_y: shita_y,
          _tx: _tx,
          _ty: _ty,
          _ox: _ox,
          _oy: _oy,
          _xr: _xr,
          _yr: _yr,
        }
      end

      # "同銀" のような人間向けの表記を返す
      def to_s
        s = []

        if @hand_log.point_same_p
          s << "同" + @options[:same_suffix]
        else
          s << @hand_log.point.name
        end

        s << @hand_log.piece.some_name(@hand_log.promoted)

        # motion1 / motion2 で分けない方がよいな
        if @hand_log.strike_trigger
          # 日本将棋連盟 棋譜の表記方法
          # https://www.shogi.or.jp/faq/kihuhyouki.html
          #
          # > 到達地点に盤上の駒が移動することも、持駒を打つこともできる場合
          # > 盤上の駒が動いた場合は通常の表記と同じ
          # > 持駒を打った場合は「打」と記入
          # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
          if @options[:strike_force] || candidate.present?
            s << "打"
          end
        else
          # "打" ではないときだけ
          if koreru_c >= 2
            if @hand_log.piece.brave?
              s << brave_motion
            else
              s << normal_motion
            end
          end
        end

        # motion2
        if true
          if @hand_log.promote_trigger
            s << "成"
          else
            if @hand_log.origin_point && @hand_log.point         # 移動した and
              if @hand_log.origin_point.promotable?(location) || # 移動元が相手の相手陣地 or
                  @hand_log.point.promotable?(location)          # 移動元が相手の相手陣地
                unless @hand_log.promoted                        # 成ってない and
                  if @hand_log.piece.promotable?                 # 成駒になれる
                    s << "不成" # or "生"
                  end
                end
              end
            end
          end
        end

        s = s.join

        # 3文字以上なら詰める
        if @options[:compact]
          if s.size > 3
            s = s.remove(/\p{blank}/)
          end
        end

        if @options[:with_mark]
          s = location.mark + s
        end

        s
      end

      private

      def brave_motion
        # 大駒の場合、
        # 【移動元で二つの龍が水平線上にいる】or【移動先の水平線上よりすべて上かすべて下】
        if idou_moto_no_ryu_ga_suihei_ni_iru || [     # 移動元で二つの龍が水平線上にいる
            candidate.all?{|s|s.point.y.value < _ty},   # 移動先の水平線上よりすべて上または
            candidate.all?{|s|s.point.y.value > _ty},   #                     すべて下
          ].any?

          sorted_candidate = candidate.sort_by{|soldier|soldier.point.x.value}
          if sorted_candidate.last.point.x.value == _ox
            _i("右")
          elsif sorted_candidate.first.point.x.value == _ox
            _i("左")
          end
        else
          if _oy < _ty
            _i("引")
          elsif _oy > _ty
            _i("上")
          elsif _oy == _ty
            "寄"
          end
        end
      end

      def normal_motion
        s = ""
        case
        when koreru_c >= 3
          case
          when _oy == _ty && yoreru_c == 1 # (_tx == (_ox + 1) || _tx == (_ox - 1)) # 3B 寄る(ことができる)駒が1枚しかないので「寄」のみ
            s << "寄"
          when _ox == _tx && (_ty + 1) == _oy # P3B
            s << _w("直", "引")
          when _ox == _tx && (_ty - 1) == _oy # P3B
            s << _w("引", "直")

          when _hidari_idou && _migi_kara_c == 1 # P3B, P3C
            s << _i("右")
          when _hidari_idou && _migi_kara_c >= 2 && _ue_idou # P3B
            s << _i("右") + _i("上")
          when _hidari_idou && _migi_kara_c >= 2 && _shita_idou # P3B, P3C
            s << _i("右") + _i("引")

          when _migi_idou && _hidari_kara_c == 1
            s << _i("左")
          when _migi_idou && _hidari_kara_c >= 2 && _ue_idou # P3B
            s << _i("左") + "上"
          when _migi_idou && _hidari_kara_c >= 2 && _shita_idou # P3B, P3C
            s << _i("左") + "引"
          end
        when agareru_c >= 2 && shita_y == _oy && _ox == _tx # P2D 例外で、金銀が横に2枚以上並んでいる場合のみ1段上に上がる時「直」
          s << "直"
        when agareru_c == 2 # P2A 同じ駒で上がる駒が2枚ある場合「上」を省略して「左」「右」
          if _hidari_idou
            s << _i("右")
          elsif _migi_idou
            s << _i("左")
          else
            raise MustNotHappen
          end
        when yoreru_c == 2 # P2B 同じ駒で寄る駒が2枚ある場合「寄」を省略して「左」「右」
          if _hidari_idou
            s << _i("右")
          elsif _migi_idou
            s << _i("左")
          else
            raise MustNotHappen
          end
        when sagareru_c == 2 # P2C 同じ駒で引く駒が2枚ある場合「引」を省略して「左」「右」
          if _hidari_idou
            s << _i("右")
          elsif _migi_idou
            s << _i("左")
          else
            raise MustNotHappen
          end
        else
          # P1A P1B P1C P1D P1E 到達地点に複数の同じ駒が動ける場合、「上」または「寄」または「引」
          case
          when _ue_idou
            s << _w("上", "引")
          when _shita_idou
            s << _w("引", "上")
          when _ty == _oy
            s << "寄"
          else
            raise MustNotHappen
          end
        end
        s
      end

      # →
      def _migi_idou
        _ox < _tx
      end

      # ←
      def _hidari_idou
        _tx < _ox
      end

      # ↑
      def _ue_idou
        _ty < _oy
      end

      # ↓
      def _shita_idou
        _oy < _ty
      end

      # 移動先にこれる数
      def koreru_c
        candidate.count
      end

      # 左からこれる数
      def _hidari_kara_c
        candidate.count { |s| s.point.x.value < _tx }
      end

      # 右からこれる数
      def _migi_kara_c
        candidate.count { |s| s.point.x.value > _tx }
      end

      # 寄れる数 (水平ラインから移動できる駒数)
      def yoreru_c
        candidate.count { |s| s.point.y.value == _ty }
      end

      # 上がれる数(移動先より下にある数)
      def agareru_c
        candidate.count { |s| s.point.y.value.send(_i(:>), _ty) }
      end

      # 下がれる数(移動先より上にある数)
      def sagareru_c
        candidate.count { |s| s.point.y.value.send(_i(:<), _ty) }
      end

      # 移動先X
      def _tx
        @_tx ||= @hand_log.point.x.value
      end

      # 移動元Y
      def _ty
        @_ty ||= @hand_log.point.y.value
      end

      # プレイヤーの視点から見た移動先の一つ下
      def shita_y
        _ty + _i(1)
      end

      # 移動元X
      def _ox
        @_ox ||= @hand_log.origin_point.x.value
      end

      # 移動先Y
      def _oy
        @_oy ||= @hand_log.origin_point.y.value
      end

      # 候補手の座標範囲
      def _xr
        @_xr ||= Range.new(*candidate.collect { |e| e.point.x.value }.minmax)
      end

      def _yr
        @_yr ||= Range.new(*candidate.collect { |e| e.point.y.value }.minmax)
      end

      def candidate
        @hand_log.candidate || []
      end

      # 移動元で二つの龍が水平線上にいる
      def idou_moto_no_ryu_ga_suihei_ni_iru
        candidate.collect { |e| e.point.y.value }.uniq.size == 1
      end

      def location
        @hand_log.player.location
      end

      concerning :InvertMethods do
        private

        def _w(*values)
          location.which_val(*values)
        end

        def _i(v)
          _w(v, invertable_hash[v])
        end

        def invertable_hash
          @invertable_hash ||= inertable_one_side_hash.merge(inertable_one_side_hash.invert)
        end

        def inertable_one_side_hash
          {
            1 => -1,
            "右" => "左",
            "引" => "上",
            :< => :>,
          }
        end
      end
    end
  end
end
