module Bushido
  module Parser
    class Header
      def to_h
        object
      end

      def []=(key, value)
        v = normalize_value(value)
        if v.present?
          object[key] = v
        end
      end

      def [](key)
        object[key]
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

      def ki2_parse(source)
        # 厳密ではないけど上部に絞る
        if md = source.match(/(?<header_dirty_part>.*?)^(#{KifParser.kif_separator}|[▲△]|まで)/mo)
          source = md[:header_dirty_part]
        end

        # 一行になっている「*解説：佐藤康光名人　聞き手：矢内理絵子女流三段」を整形する
        source = source.gsub(/\p{blank}/, " ")
        source = source.gsub(/[\*\s]+(解説|聞き手)：\S+/) { |s| "\n#{s.strip}\n" }

        source.scan(/^(\S.*)#{Base.header_sep}(.*)$/o).each do |key, value|
          if key.start_with?("#")
            next
          end
          key = key.remove(/^\*+/)
          self[key] = value
        end

        # @raw_header = header.dup

        # 「a」vs「b」を取り込む
        if md = source.match(/\*「(.*?)」?vs「(.*?)」?$/)
          sente_gote.each.with_index do |e, i|
            key = "#{e}詳細"
            v = normalize_value(md.captures[i])
            self[key] = v
            # meta_info[key] = v
          end
        end
      end

      def sente_gote
        Location.collect { |e| e.public_send(hirate_or_komochi) }
      end

      # 消す予定

      def __to_meta_h
        [
          object,
          __to_simple_names_h,
        ].compact.inject(&:merge)
      end

      # ["中倉宏美", "伊藤康晴"]
      def __to_simple_names_h
        sente_gote.inject({}) { |a, e|
          a.merge(e => pair_split(object[e]))
        }
      end

      private

      # "清水市代・フレデリックポティエ"    => ["清水市代", "フレデリックポティエ"]
      # "清水市代＆フレデリック・ポティエ"  => ["清水市代", "フレデリックポティエ"]
      def pair_split(s)
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
              if v = (Time.parse(v) rescue nil)
                format = "%Y/%m/%d"
                unless [v.hour, v.min, v.sec].all?(&:zero?)
                  format = "#{format} %T"
                end
                object[key] = v.strftime(format)
              end
            end
          end
        end
      end

      def piece_order_normalize
        sente_gote.each do |e|
          e = "#{e}の持駒"
          if v = object[e].presence
            v = Utils.hold_pieces_s_to_a(v)
            v = Utils.hold_pieces_a_to_s(v, ordered: true, separator: " ")
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
      def hirate_or_komochi
        @hirate_or_komochi ||= -> {
          if Location.none? { |e| object[e.komaochi_name] }
            :hirate_name
          else
            :komaochi_name
          end
        }.call
      end
    end
  end
end
