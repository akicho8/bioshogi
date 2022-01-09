module Bioshogi
  module Parser
    class Header
      delegate :[], :to_h, :delete, :has_key?, to: :object

      attr_accessor :force_location

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

      def call_names
        @call_names ||= -> {
          v = handicap_validity
          Location.collect { |e| e.call_name(v) }
        }.call
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

        # if Location.any? {|e| object.has_key?(e.handicap_name) || object.has_key?("#{e.handicap_name}の持駒") }
        #   return true
        # end
        # 
        # if Location.any? {|e| object.has_key?(e.equality_name) || object.has_key?("#{e.equality_name}の持駒") }
        #   return false
        # end

        nil
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


      def inspect
        av = []
        av << "* header attributes"
        av << object.to_t.strip
        av << " "

        av << "* header methods (read)"
        av << {
          :handicap_validity => handicap_validity,
          :force_location    => force_location,
        }.to_t.strip
        av << " "

        av.join("\n").strip
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
    end
  end
end
