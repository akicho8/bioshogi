module Bioshogi
  module Parser
    class Header
      delegate :[], :to_h, :delete, :has_key?, to: :object

      attr_accessor :object

      def initialize(*args)
        @object = Hash[*args]
      end

      def []=(key, value)
        if v = normalize_value(value).presence
          object[key] = v
        end
      end

      def inspect
        object.to_t.strip
      end

      def clone
        self.class.new(object.clone)
      end

      def normalize
        time_normalize
        piece_normalize
      end

      private

      def time_normalize
        object.each do |key, value|
          if key.match?(/日時?\z/) # "開始日" や "開始日時"
            if v = value.presence
              t = TimeParser.new(v).to_time
              if t
                format = "%Y/%m/%d"
                if false
                  if key.match?(/時\z/)
                    format = "#{format} %T"
                  end
                else
                  if t.hour == 0 && t.min == 0 && t.sec == 0
                  else
                    format = "#{format} %T"
                  end
                end
                object[key] = t.strftime(format)
              end
            end
          end
        end
      end

      def piece_normalize
        Location.each do |e|
          e.call_names.each do |e|
            key = "#{e}の持駒"
            if v = object[key].presence
              v = Piece.s_to_a(v)
              v = Piece.a_to_s(v, ordered: true, separator: " ")
              if v.present?
                object[key] = v
              else
                object.delete(key)
              end
            end
          end
        end
      end

      def normalize_value(s)
        s = s.gsub(/\p{blank}+/, " ")
        s = s.tr("ａ-ｚＡ-Ｚ０-９", "a-zA-Z0-9")
        s = s.strip
        s
      end
    end
  end
end
