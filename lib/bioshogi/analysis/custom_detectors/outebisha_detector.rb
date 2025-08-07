# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class OutebishaDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          retval = perform_block do
            # 【条件】角を操作した
            and_cond { soldier.piece.key == own_piece }
          end

          if retval
            founds = []
            king_found = false
            V.public_send(own_piece_vector).each do |e|
              (1..Float::INFINITY).each do |magnification|
                if v = soldier.relative_move_to(e, magnification: magnification)
                  if s = board[v]
                    if opponent?(s)
                      if s.piece.key == :king
                        king_found = true
                      elsif s.piece.key == target_piece
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
              tag_add(tag_first)
            when there_king_on_other_side_of_rook?(founds)
              tag_add(tag_second)
            when founds.many?
              tag_add("両取り")
              tag_add(tag_third)
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

        def own_piece
          :bishop
        end

        def own_piece_vector
          :saltire_vectors
        end

        def target_piece
          :rook
        end

        def tag_first
          "王手飛車"
        end

        def tag_second
          "準王手飛車"
        end

        def tag_third
          "角による両取り"
        end
      end
    end
  end
end
