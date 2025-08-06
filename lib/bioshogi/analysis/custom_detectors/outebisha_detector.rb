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
            and_cond { soldier.piece.key == :bishop }
          end

          if retval
            # 【条件】当たり判定
            founds = []
            king_found = false
            V.saltire_vectors.each do |e|
              # p e
              (1..Float::INFINITY).each do |magnification|
                if v = soldier.relative_move_to(e, magnification: magnification)
                  if s = board[v]
                    if opponent?(s)
                      if s.piece.key == :king
                        king_found = true
                        break
                      elsif s.piece.key == :rook
                        founds << [e, magnification]
                        break
                      else
                        # 相手の駒だけど弱い駒なので終わる
                        break
                      end
                    else
                      # 自分の駒なので終わる
                      break
                    end
                  else
                    # 空なので続ける
                  end
                else
                  # 場外なので終わる
                  break
                end
              end
              if king_found && founds.present?
                # 王手飛車状態が確定している
                break
              end
            end

            # p king_found
            # p founds.present?
            # p jun_outebisya_p(founds)

            case
            when king_found && founds.present?
              tag_add("王手飛車")
            when jun_outebisya_p(founds)
              tag_add("準王手飛車")
            when founds.many?
              tag_add("両取り")
            end
          end
        end

        def jun_outebisya_p(founds)
          king_found = false
          founds.each do |e, magnification|
            (magnification.next..Float::INFINITY).each do |magnification|
              if v = soldier.relative_move_to(e, magnification: magnification)
                if s = board[v]
                  if opponent?(s)
                    if s.piece.key == :king
                      king_found = true
                      break
                    else
                      # 相手の駒だけど玉ではないので終わる
                      break
                    end
                  else
                    # 自分の駒なので終わる
                    break
                  end
                else
                  # 空なので続ける
                end
              else
                # 場外なので終わる
                break
              end
            end
          end
          king_found
        end
      end
    end
  end
end
