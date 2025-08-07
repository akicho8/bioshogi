# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class Outebisha2Detector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          retval = perform_block do
            # 【条件】角を操作した
            and_cond { soldier.piece.key == :rook }
          end

          if retval
            founds = []
            king_found = false
            V.cross_vectors.each do |e|
              (1..Float::INFINITY).each do |magnification|
                if v = soldier.relative_move_to(e, magnification: magnification)
                  if s = board[v]
                    if opponent?(s)
                      if s.piece.key == :king
                        king_found = true
                      elsif s.piece.key == :bishop
                        founds << [e, magnification]
                      end
                    end
                    break # 駒があるので終わる
                  else
                    # 空
                  end
                else
                  break # 場外
                end
              end
              if king_found && founds.present?
                # この時点で王手飛車状態が確定している
                break
              end
            end

            case
            when king_found && founds.present?
              tag_add("王手角")
            when there_king_on_other_side_of_rook?(founds)
              tag_add("準王手角")
            when founds.many?
              tag_add("両取り")
              tag_add("飛車による両取り")
            end
          end
        end

        # 飛の向こう側に玉がいるか？
        def there_king_on_other_side_of_rook?(founds)
          founds.any? do |e, magnification|
            king_found = false
            (magnification.next..Float::INFINITY).each do |magnification|
              if v = soldier.relative_move_to(e, magnification: magnification)
                if s = board[v]
                  if opponent?(s)
                    if s.piece.key == :king
                      king_found = true
                      break
                    else
                      break # 相手の駒
                    end
                  else
                    break # 自分の駒
                  end
                else
                  # 空なので続ける
                end
              else
                break # 場外
              end
            end
            king_found
          end
        end
      end
    end
  end
end
