# frozen-string-literal: true

module Warabi
  class FooTesujiInfo
    include ApplicationMemoryRecord
    memory_record [
      {wars_code: nil, key: "金底の歩", parent: nil, other_parents: nil, alias_names: nil, turn_limit: nil, turn_eq: nil, order_key: nil, not_have_pawn: nil,  kill_only: nil,  drop_only: nil, not_have_anything_except_pawn: nil,  cold_war: nil,  hold_piece_not_in: nil,  hold_piece_in: nil,  hold_piece_empty: nil, hold_piece_eq: nil, check_method: :kinzoko_check},
    ]

    include PresetInfo::DelegateToShapeInfoMethods
    include DefenseInfo::AttackInfoSharedMethods

    def tactic_key
      :foo_tesuji
    end

    def siratama_url
    end

    def check_method_execute(*args)
      send(check_method, *args)
    end

    ################################################################################

    def kinzoko_check(skill_monitor)
      skill_monitor.instance_eval do
        if false
          p executor.drop_hand
          soldier = executor.drop_hand.soldier
          p soldier.piece.key
          p soldier.advance_level
          p soldier.place
          p Place.lookup([soldier.place.x.value, soldier.place.y.value - soldier.location.value_sign])
        end

        # 「打」でないとだめ
        unless executor.drop_hand
          throw :skip
        end

        soldier = executor.drop_hand.soldier

        # 「最下段」でないとだめ
        unless soldier.advance_level == 0
          throw :skip
        end

        # 「歩」でないとだめ
        unless soldier.piece.key == :pawn
          throw :skip
        end

        # 1つ上の位置
        place = soldier.place
        v = Place.lookup([place.x.value, place.y.value - soldier.location.value_sign])

        # 1つ上の位置になにかないとだめ
        unless v = surface[v]
          throw :skip
        end

        # 1つ上の駒が「自分」の「金」でないとだめ
        unless v.piece.key == :gold && v.location == soldier.location
          throw :skip
        end
      end
    end
  end
end
