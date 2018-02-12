# frozen-string-literal: true

module Warabi
  class OfficialFormatter
    attr_reader :base
    attr_reader :options

    def initialize(base, **options)
      @options = {
        with_mark: false,    # 先手後手のマークを入れる？
        direct_force: false, # 「打」を省略できるときでも「打」を明示する？
        same_suffix: "",     # 「同」の後に入れる文字列
        compact: true,       # 3文字を超えたらとき空白が含まれていれば詰める？
      }.merge(options)

      @base = base
    end

    def to_debug_hash
      {
        :point_from     => point_from,
        :point_to       => point_to,
        :candidate      => candidate.collect(&:name),
        :koreru_c       => koreru_c,
        :_migi_idou     => _migi_idou?,
        :_hidari_idou   => _hidari_idou?,
        :_ue_idou       => _ue_idou?,
        :_shita_idou    => _shita_idou?,
        :_hidari_kara_c => _hidari_kara_c,
        :_migi_kara_c   => _migi_kara_c,
        :yoreru_c       => yoreru_c,
        :agareru_c      => agareru_c,
        :sagareru_c     => sagareru_c,
        :shita_y        => shita_y,
        :_tx            => _tx,
        :_ty            => _ty,
        :_ox            => _ox,
        :_oy            => _oy,
        :_xr            => _xr,
        :_yr            => _yr,
      }
    end

    def to_s
      s = []

      if base.point_same
        s << "同" + @options[:same_suffix]
      else
        s << point_to.name
      end

      if direct_trigger?
        s << piece.name

        # 日本将棋連盟 棋譜の表記方法
        # https://www.shogi.or.jp/faq/kihuhyouki.html
        #
        # > 到達地点に盤上の駒が移動することも、持駒を打つこともできる場合
        # > 盤上の駒が動いた場合は通常の表記と同じ
        # > 持駒を打った場合は「打」と記入
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。それ以外の場合は、持駒を打つ場合も「打」はつけません。
        if @options[:direct_force] || !candidate.empty?
          s << "打"
        end
      else
        if promote_trigger?
          s << piece.name
          s << motion
          s << "成"
        else
          s << soldier.any_name
          s << motion
          if point_from && point_to           # 移動した and
            if point_from.promotable?(location) || # 移動元が相手の相手陣地 or
                point_to.promotable?(location)     # 移動元が相手の相手陣地
              unless promoted                           # 成ってない and
                if piece.promotable?               # 成駒になれる
                  s << "不成" # or "生"
                end
              end
            end
          end
        end
      end

      s = s.join

      # 3文字以上なら空白を詰める
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

    def motion
      if koreru_c >= 2
        if piece.brave?
          brave_motion
        else
          basic_motion
        end
      end
    end

    def brave_motion
      # 連盟の複雑そうなルールをコードに落とし込むには次の方法でよさそう
      #
      #  左右だけがつく場合
      #
      #   1. 移動元で二つの龍が水平線上にいる
      #   2. または、水平線上よりすべて上かすべて下
      #
      #  1, 2 に該当しなかったら
      #
      #   ・下移動なら → 引
      #   ・上移動なら → 上
      #   ・横移動なら → 寄
      #
      if idou_moto_no_ryu_ga_suihei_ni_iru? || idousakino_suiheisenjou_yori_subete_ue_mataha_shita?
        case
        when _xr.max == _ox
          _i("右")
        when _xr.min == _ox
          _i("左")
        else
          raise MustNotHappen
        end
      else
        case
        when _shita_idou?
          _i("引")
        when _ue_idou?
          _i("上")
        when yoko_idou?
          "寄"
        end
      end
    end

    def basic_motion
      case
      when koreru_c >= 3
        case
        when yoko_idou? && yoreru_c == 1 # 3B 寄る(ことができる)駒が1枚しかないので「寄」のみ
          "寄"
        when yoko_idou? && yoreru_c >= 2 # P3B_A 寄る(ことができる)駒が2枚以上なので「左右」＋「寄」
          case
          when _hidari_idou?
            _i("右") + "寄"
          when _migi_idou?
            _i("左") + "寄"
          else
            raise MustNotHappen
          end
        when tate_idou? && (_ty + 1) == _oy # P3B
          _w("直", "引")
        when tate_idou? && (_ty - 1) == _oy # P3B
          _w("引", "直")

        when _hidari_idou? && _migi_kara_c == 1 # P3B, P3C
          _i("右")
        when _hidari_idou? && _migi_kara_c >= 2 && _ue_idou? # P3B
          _i("右") + _i("上")
        when _hidari_idou? && _migi_kara_c >= 2 && _shita_idou? # P3B, P3C
          _i("右") + _i("引")

        when _migi_idou? && _hidari_kara_c == 1
          _i("左")
        when _migi_idou? && _hidari_kara_c >= 2 && _ue_idou? # P3B
          _i("左") + _i("上")
        when _migi_idou? && _hidari_kara_c >= 2 && _shita_idou? # P3B, P3C
          _i("左") + _i("引")
        else
          raise MustNotHappen
        end
      when agareru_c >= 2 && shita_y == _oy && tate_idou? # P2D 例外で、金銀が横に2枚以上並んでいる場合のみ1段上に上がる時「直」
        "直"
      when agareru_c == 2 # P2A 上がる駒が2枚ある場合「上」を省略して「左」「右」
        case
        when _hidari_idou?
          _i("右")
        when _migi_idou?
          _i("左")
        else
          raise MustNotHappen
        end
      when yoreru_c == 2 # P2B 寄る駒が2枚ある場合「寄」を省略して「左」「右」
        case
        when _hidari_idou?
          _i("右")
        when _migi_idou?
          _i("左")
        else
          raise MustNotHappen
        end
      when sagareru_c == 2 # P2C 引く駒が2枚ある場合「引」を省略して「左」「右」
        case
        when _hidari_idou?
          _i("右")
        when _migi_idou?
          _i("左")
        else
          raise MustNotHappen
        end
      else
        # P1A P1B P1C P1D P1E 到達地点に複数の同じ駒が動ける場合、「上」または「寄」または「引」
        case
        when _ue_idou?
          _w("上", "引")
        when _shita_idou?
          _w("引", "上")
        when _ty == _oy
          "寄"
        else
          raise MustNotHappen
        end
      end
    end

    # →
    def _migi_idou?
      _ox < _tx
    end

    # ←
    def _hidari_idou?
      _tx < _ox
    end

    # ↑
    def _ue_idou?
      _ty < _oy
    end

    # ↓
    def _shita_idou?
      _oy < _ty
    end

    # 左右移動
    def yoko_idou?
      _oy == _ty
    end

    # 上下移動
    def tate_idou?
      _ox == _tx
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
      @_tx ||= point_to.x.value
    end

    # 移動元Y
    def _ty
      @_ty ||= point_to.y.value
    end

    # プレイヤーの視点から見た移動先の一つ下
    def shita_y
      _ty + _i(1)
    end

    # プレイヤーの視点から見た移動先の一つ上
    def ue_y
      _ty + _i(-1)
    end

    # 移動元X
    def _ox
      @_ox ||= point_from.x.value
    end

    # 移動先Y
    def _oy
      @_oy ||= point_from.y.value
    end

    # 候補手の座標範囲
    def _xr
      @_xr ||= Range.new(*candidate.collect { |e| e.point.x.value }.minmax)
    end

    def _yr
      @_yr ||= Range.new(*candidate.collect { |e| e.point.y.value }.minmax)
    end

    # 移動元で二つの龍が水平線上にいる
    def idou_moto_no_ryu_ga_suihei_ni_iru?
      candidate.collect { |e| e.point.y.value }.uniq.size == 1
    end

    # 移動先の水平線上よりすべて上 or すべて下
    # つまり、移動先のYが候補のYの範囲に含まれている
    # だから candidate.all?{|s|s.point.y.value < _ty} || candidate.all?{|s|s.point.y.value > _ty} から !_yr.cover?(_ty) に変更できる
    def idousakino_suiheisenjou_yori_subete_ue_mataha_shita?
      !_yr.cover?(_ty)
    end

    delegate :direct_hand, :moved_hand, :soldier, :hand, :candidate, to: :base
    delegate :point, :piece, :location, :promoted, to: :soldier

    def direct_trigger?
      direct_hand
    end

    def promote_trigger?
      if moved_hand
        moved_hand.promote_trigger?
      end
    end

    def point_from
      if moved_hand
        moved_hand.origin_soldier.point
      end
    end

    def point_to
      point
    end

    concerning :InvertMethods do
      private

      def _w(*values)
        location.which_val(*values)
      end

      def _i(v)
        _w(v, invertable_hash.fetch(v))
      end

      def invertable_hash
        @invertable_hash ||= invertable_one_side_hash.merge(invertable_one_side_hash.invert)
      end

      def invertable_one_side_hash
        {
          1    => -1,
          "右" => "左",
          "引" => "上",
          :<   => :>,
        }
      end
    end
  end
end
