# frozen-string-literal: true

module Bioshogi
  module BoardParser
    class CompareBoardParser < KakinokiBoardParser
      def parse
        cell_walker do |place, prefix_char, something|
          case
          when Piece.all_names_set.include?(something)
            case prefix_char
            when "!"
              # トリガーとする。盤面には含めない(含める必要がないため)
              soldier = build(place, something, :black)
              trigger_soldiers << soldier
            when "@"
              # ! と同じだけど、盤面情報に含める(複数トリガーを書くとき用)
              soldier = build(place, something, :black)
              trigger_soldiers << soldier
              soldiers << soldier # 盤面の駒とする
            when "*"
              # ▲でどれかがここに含まれる
              soldier = build(place, something, :black)
              any_exist_soldiers << soldier # FIXME: ここと
            when "?"
              # △側でどれかがここに含まれる
              soldier = build(place, something, :white)
              any_exist_soldiers << soldier # FIXME: ここは別で管理するべき？
            when "~"
              # ▲でここに含まれない
              soldier = build(place, something, :black)
              not_exist_soldiers << soldier
            else
              soldier = build(place, something, prefix_char)
              soldiers << soldier
            end
          when something != "・"
            other_objects << {place: place, prefix_char: prefix_char, something: something}
          end
        end
      end

      def other_objects
        @other_objects ||= []
      end

      # この手を指したときに発動する盤上の駒リスト
      def trigger_soldiers
        @trigger_soldiers ||= SoldierBox.new
      end

      # どれかが含まれる用
      def any_exist_soldiers
        @any_exist_soldiers ||= SoldierBox.new
      end

      # 含まれない用
      def not_exist_soldiers
        @not_exist_soldiers ||= SoldierBox.new
      end

      # 高速に比較するためにメモ化したアクセサシリーズ

      # something のグループ化
      def other_objects_hash_ary
        @other_objects_hash_ary ||= other_objects.group_by { |e| e[:something] }
      end

      # something のグループ化 + place 毎のハッシュ
      def other_objects_hash
        @other_objects_hash ||= other_objects_hash_ary.transform_values { |v| v.inject({}) { |a, e| a.merge(e[:place] => e) } }
      end

      # other_objects_hash_ary + 末尾配列
      def other_objects_loc_ary
        @other_objects_loc_ary ||= Location.inject({}) do |a, l|
          hash = other_objects_hash_ary.transform_values { |v|
            v.collect { |e| e.merge(place: e[:place].public_send(l.normalize_key)) }
          }
          a.merge(l.key => hash)
        end
      end

      # other_objects_hash_ary + 末尾 place のハッシュ
      def other_objects_loc_places_hash
        @other_objects_loc_places_hash ||= Location.inject({}) do |a, l|
          places_hash = other_objects_hash_ary.transform_values do |v|
            v.inject({}) { |a, e|
              e = e.merge(:place => e[:place].public_send(l.normalize_key))
              a.merge(e[:place] => e)
            }
          end
          a.merge(l.key => places_hash)
        end
      end

      # テーブルのキーとする駒すべて
      # プライマリー駒があると絞れるのでなるべく付けたい
      # プライマリー駒がないと、他すべてをプライマリー駒と見なす
      def primary_soldiers
        @primary_soldiers ||= Array(trigger_soldiers.presence || soldiers.presence)
      end
    end
  end
end
