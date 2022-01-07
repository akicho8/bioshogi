module Bioshogi
  module Parser
    class Header
      delegate :[], :to_h, :delete, to: :object
      attr_reader :turn_base
      attr_reader :force_location

      cattr_accessor(:system_comment_char) { "#" }

      def []=(key, value)
        v = normalize_value(value)
        if v.present?
          object[key] = v
        end
      end

      def normalize_all
        time_format_normalize
        piece_order_normalize
      end

      def object
        @object ||= {}
      end

      def meta_info
        @meta_info ||= {}
      end

      def parse_from_kif_format_header(source)
        # 厳密ではないけど上部に絞る
        if md = source.match(/(?<header_dirty_part>.*?)^(#{KifParser.kif_separator}|[▲△]|まで)/mo)
          source = md[:header_dirty_part]
        end

        # 扱いやすいように全角スペースを半角化
        source = source.gsub(/\p{blank}/, " ")

        # システムコメント行を削除
        source = source.remove(/^\s*#{system_comment_char}.*(\R|$)/o)

        # 一行になっている「*解説：佐藤康光名人　聞き手：矢内理絵子女流三段」を整形する
        source = source.gsub(/[\*\s]+(解説|聞き手)：\S+/) { |s| "\n#{s.strip}\n" }

        # ぴよ将棋の「手合割：その他」があると手合割にその他は存在しないため削除する
        source = source.sub(/^\s*手合割：その他.*(\R|$)/, "")

        # ヘッダーは自由にカスタマイズできるのに何かのソフトの都合で受け入れられないキーワードがあるらしく、
        # "*キー：値" のように * でコメントアウトしてヘッダーを入れている場合がある
        # そのため * を外して取り込んでいる → そのまま取り込むことにする(2020-11-16)
        #
        # "foo\nbar:1".scan(/^([^:\n]+):(.*)/).to_a # => [["bar", "1"]]
        #
        source.scan(/^\s*([^#{Base.header_sep}\n]+)#{Base.header_sep}(.*)$/o).each do |key, value|
          # key = key.remove(/^\*+/)
          self[key.strip] = value.strip
        end

        # @raw_header = header.dup

        # 「a」vs「b」を取り込む
        if md = source.match(/\*「(.*?)」?vs「(.*?)」?$/)
          call_names.each.with_index do |e, i|
            key = "#{e}詳細"
            v = normalize_value(md.captures[i])
            self[key] = v
            # meta_info[key] = v
          end
        end

        # BOD風の指定があれば取り込む
        if md = source.match(/^手数(＝|=)(?<turn_base>\d+)/)
          @turn_base = md[:turn_base].to_i
        end

        # 「後手番」の指定があれば
        Location.each do |location|
          if location.call_names.any? { |name| source.match?(/^#{name}番/) }
            @force_location = location
            break
          end
        end
      end

      def call_names
        @call_names ||= -> {
          v = handicap_validity
          Location.collect { |e| e.call_name(v) }
        }.call
      end

      # 消す予定

      def __to_meta_h
        [
          object,
          entry_all_names,
        ].compact.inject(&:merge)
      end

      # ["中倉宏美", "伊藤康晴"]
      def entry_all_names
        call_names.inject({}) { |a, e|
          a.merge(e => name_value_split(object[e]))
        }
      end

      # ヘッダー情報からのみで駒落ちかどうかを判定する
      # 駒落ち判定順序
      # 1. 手合割があれば正規化して平手以外であれば
      # 2. 下手・上手の言葉が使われていれば
      def handicap_validity
        preset_info = PresetInfo[object["手合割"]]
        if preset_info
          return preset_info.handicap
        end

        # 柿木将棋Ⅸ V9.35 の詰将棋KIFの場合
        #
        # 問題点
        # 上手下手表記になっている → だから駒落ちだと想定
        # しかし実際はただの詰将棋 → なんで駒落ち関係ないのに上手・下手表記なのか
        # このせいで上手・下手表記で駒落ちと判定はできなくなった
        #
        # 対策
        # ここで「手合割」は「その他」になっているので上手・下手のチェックをする前に
        # 「その他」なら平手、つまり「駒落ちではない」とする
        #
        # if object["手合割"] == "その他"
        #   return false
        # end

        if Location.any? {|e| object.has_key?(e.handicap_name) || object.has_key?("#{e.handicap_name}の持駒") }
          return true
        end

        if Location.any? {|e| object.has_key?(e.equality_name) || object.has_key?("#{e.equality_name}の持駒") }
          return false
        end

        nil
      end

      private

      # "清水市代・フレデリックポティエ"    => ["清水市代", "フレデリックポティエ"]
      # "清水市代＆フレデリック・ポティエ"  => ["清水市代", "フレデリックポティエ"]
      def name_value_split(s)
        if s
          if s.include?("＆")
            s.split("＆")
          else
            s.split("・")
          end
        end
      end

      def time_format_normalize
        object.each do |key, value|
          if key.match(/日時?\z/)
            if v = value.presence
              case
              when t = Time.parse(v) rescue nil
                time_reformat_and_store(key, t)
              when t = Time.local(*v.scan(/\d+/).collect(&:to_i)) rescue nil
                time_reformat_and_store(key, t)
              end
            end
          end
        end
      end

      def time_reformat_and_store(key, t)
        format = "%Y/%m/%d"
        if [t.hour, t.min, t.sec].any?(&:nonzero?)
          format = "#{format} %T"
        end
        object[key] = t.strftime(format)
      end

      def piece_order_normalize
        call_names.each do |e|
          e = "#{e}の持駒"
          if v = object[e].presence
            v = Piece.s_to_a(v)
            v = Piece.a_to_s(v, ordered: true, separator: " ")
            object[e] = v
          end
        end
      end

      def normalize_value(s)
        s = s.gsub(/\p{blank}/, " ")

        # ここでスペースととると ", " が "," になるのはいやかも
        # unless s.match?(/\A\p{ASCII}*\z/)
        #   s = s.remove(/\s+/)
        # end

        # s = s.tr("ａ-ｚＡ-Ｚ０-９()", "a-zA-Z0-9（）")
        s = s.tr("ａ-ｚＡ-Ｚ０-９", "a-zA-Z0-9")
        # s = NKF.nkf('-w -Z', s) # => "a-zA-Z0-9()"

        # 「01:02」はそのままで「第001回」は「第1回」に置換する
        if s.match?(/\A[▲△\p{ASCII}]+\z/)
          # 「▲001△001」の場合は飛ばす
        else
          s = s.gsub(/(?<number>\d+)(?<kanji>\p{^ASCII})/) { |s| # 「01回」->「1回」
            md = Regexp.last_match
            "#{md[:number].to_i}#{md[:kanji]}"
          }
        end

        s
      end

      # 「上手」「下手」の文字がなければ「平手」と見なしている
      # 棋譜を見ずにヘッダーだけで推測している点に注意
      def equality_or_handicap
        if handicap_validity
          :handicap_name
        else
          :equality_name
        end
      end
    end
  end
end
