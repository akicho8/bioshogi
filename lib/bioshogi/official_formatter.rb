# frozen-string-literal: true

module Bioshogi
  class OfficialFormatter
    attr_reader :hand_log
    attr_reader :options

    delegate :drop_hand, :move_hand, :soldier, :hand, :candidate_soldiers, :handicap, to: :hand_log
    delegate :place, :piece, :location, :promoted, to: :soldier

    def initialize(hand_log, options = {})
      @options = {
        :with_location => false,         # 先手後手のマークを入れる？
        :force_drop    => false,         # 「打」を省略できるときでも「打」を明示する？
        :same_suffix   => "",            # 「同」の後に入れる文字列
        :separator     => "",            # "34歩" を "34 歩" のようにしたいときの隙間文字列
        :compact_if_gt => 7,             # 半角7文字幅以上なら空白除去
        :place_format  => :name,         # name は "3四" で zenkaku_number は "３４" で hankaku_number なら "34"
        :char_type     => :formal_sheet, # :formal_sheet => 駒表記を「全」ではなく「成銀」のようにする nil: 「全」
      }.merge(options)

      @hand_log = hand_log

      unless candidate_soldiers
        raise BioshogiError, "candidate_enable オプションが有効になっていないため KI2 の特殊な移動表記を作れません"
      end
    end

    def to_s
      s = []

      if location_name
        s << location_name
      end

      if hand_log.place_same
        s << kw("同") + @options[:same_suffix]
      else
        s << place_name
        s << @options[:separator]
      end

      if type == "t_drop"
        s << piece_name
        # 日本将棋連盟 棋譜の表記方法
        # https://www.shogi.or.jp/faq/kihuhyouki.html
        #
        # > 到達地点に盤上の駒が移動することも、持駒を打つこともできる場合
        # > 盤上の駒が動いた場合は通常の表記と同じ
        # > 持駒を打った場合は「打」と記入
        # > ※「打」と記入するのはあくまでもその地点に盤上の駒を動かすこともできる場合のみです。
        # > それ以外の場合は、持駒を打つ場合も「打」はつけません。
        if @options[:force_drop] || !candidate_soldiers.empty?
          s << kw("打")
        end
      elsif type == "t_promote_on"
        s << piece_name
        s << motion
        s << kw("成")
      elsif type == "t_promote_throw"
        s << piece_name
        s << motion
        s << kw("不成") # or "生"
      elsif type == "t_move"
        s << soldier_name
        s << motion
      else
        raise "must not happen"
      end

      s = s.join
      s = str_compact(s)

      if @options[:with_location]
        s = location.mark + s
      end

      s
    end

    def to_debug_hash
      {
        :place_from     => place_from,
        :place_to       => place_to,
        :candidate_soldiers      => candidate_soldiers.collect(&:name),
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

    private

    def type
      @type ||= hand.type
    end

    # 3文字以上なら空白を詰める
    def str_compact(str)
      if v = @options[:compact_if_gt]
        if str.encode("EUC-JP").bytesize >= v
          str = str.remove(/\p{blank}/)
        end
      end
      str
    end

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
          kw("寄")
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
            _i("右") + kw("寄")
          when _migi_idou?
            _i("左") + kw("寄")
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
        kw("直")
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
          kw("寄")
        else
          raise MustNotHappen
        end
      end
    end

    # 右に移動する？
    def _migi_idou?
      _ox < _tx
    end

    # 左に移動する？
    def _hidari_idou?
      _tx < _ox
    end

    # 上に移動する？
    def _ue_idou?
      _ty < _oy
    end

    # 下に移動する？
    def _shita_idou?
      _oy < _ty
    end

    # 水平に移動する？
    def yoko_idou?
      _oy == _ty
    end

    # 垂直に移動する？
    def tate_idou?
      _ox == _tx
    end

    # 移動先にこれる駒の数
    def koreru_c
      candidate_soldiers.count
    end

    # 左からこれる駒の数
    def _hidari_kara_c
      candidate_soldiers.count { |s| s.place.column.value < _tx }
    end

    # 右からこれる駒の数
    def _migi_kara_c
      candidate_soldiers.count { |s| s.place.column.value > _tx }
    end

    # 水平に寄れる駒の数
    def yoreru_c
      candidate_soldiers.count { |s| s.place.row.value == _ty }
    end

    # 上がれる駒の数(移動先より下にある数)
    def agareru_c
      candidate_soldiers.count { |s| s.place.row.value.send(_i(:>), _ty) }
    end

    # 下がれる駒の数(移動先より上にある数)
    def sagareru_c
      candidate_soldiers.count { |s| s.place.row.value.send(_i(:<), _ty) }
    end

    # 移動先X
    def _tx
      @_tx ||= place_to.column.value
    end

    # 移動元Y
    def _ty
      @_ty ||= place_to.row.value
    end

    # プレイヤー視点から見た移動先の一つ下
    def shita_y
      _ty + _i(1)
    end

    # プレイヤー視点から見た移動先の一つ上
    def ue_y
      _ty + _i(-1)
    end

    # 移動元X
    def _ox
      @_ox ||= place_from.column.value
    end

    # 移動先Y
    def _oy
      @_oy ||= place_from.row.value
    end

    # 候補手の座標範囲
    def _xr
      @_xr ||= Range.new(*candidate_soldiers.collect { |e| e.place.column.value }.minmax)
    end

    def _yr
      @_yr ||= Range.new(*candidate_soldiers.collect { |e| e.place.row.value }.minmax)
    end

    # 移動元で二つの龍が水平線上にいる？
    def idou_moto_no_ryu_ga_suihei_ni_iru?
      candidate_soldiers.collect { |e| e.place.row.value }.uniq.size == 1
    end

    # 移動先の水平線上よりすべて上 or すべて下
    # つまり、移動先のYが候補のYの範囲に含まれている
    # だから candidate_soldiers.all?{|s|s.place.row.value < _ty} || candidate_soldiers.all?{|s|s.place.row.value > _ty} から !_yr.cover?(_ty) に変更できる
    def idousakino_suiheisenjou_yori_subete_ue_mataha_shita?
      !_yr.cover?(_ty)
    end

    # # 「打」？
    # def drop_trigger?
    #   drop_hand
    # end

    # 「成」？
    # def promote_trigger?
    #   if move_hand
    #     move_hand.promote_trigger?
    #   end
    # end

    # 移動元
    def place_from
      if move_hand
        move_hand.origin_soldier.place
      end
    end

    # 移動先
    def place_to
      place
    end

    def location_name
    end

    ################################################################################ 読み方

    def piece_name
      piece.name
    end

    def place_name
      place_to.public_send(@options[:place_format])
    end

    def soldier_name
      soldier.any_name(char_type: @options[:char_type])
    end

    def kw(s)
      s
    end

    concerning :InvertMethods do
      private

      def _w(*values)
        if s = location.which_value(*values)
          if s.kind_of?(String)
            s = kw(s)
          end
        end
        s
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
