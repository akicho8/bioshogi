# frozen-string-literal: true

module Bioshogi
  module Analysis
    module CustomDetectors
      class AnagumaDetector
        include ExecuterDsl

        attr_reader :executor

        def initialize(executor)
          @executor = executor
        end

        def call
          retval = perform_block do
            # 【条件】自玉が1つ存在する
            and_cond { player.king_soldier_only_one_exist? }

            # 【条件】自玉が隅にいる
            and_cond { king_soldier.side_edge? && king_soldier.bottom_spaces == 0 }

            # 【条件】動かしたまたは打った駒は銀以上の駒である
            and_cond { soldier.abs_weight >= min_score }

            # 【却下】生の飛角 (角打ちや角移動で0枚玉が発動してしまうのを防ぐため)
            skip_if { soldier.piece.hisyakaku && soldier.normal? }

            # 【条件】駒は玉と同じ側である
            and_cond { soldier.left_or_right == king_soldier.left_or_right }

            # 【条件】駒は玉の近くである (3x3)
            and_cond { soldier.place.in_outer_area?(king_soldier.place, 2) }
          end

          if retval
            case_穴熊
            case_居飛車穴熊_or_振り飛車穴熊
            case_穴熊再生
            case_N枚穴熊
            case_角換わり穴熊
          end
        end

        private

        def case_穴熊
          player.tag_bundle << "穴熊"
        end

        def case_居飛車穴熊_or_振り飛車穴熊
          tag_add(general_tag, once: true)
        end

        def case_穴熊再生
          if drop_hand && soldier.piece.kingin
            tag_add("穴熊再生")
          end
        end

        def case_N枚穴熊
          if e = TagIndex["#{kin_gin_count}枚穴熊"]
            tag_add(e)
          end
        end

        def case_角換わり穴熊
          if container.joban
            if kakugawari?
              tag_add(:"角換わり穴熊", once: true)
            end
          end
        end

        def kakugawari?
          if false
            if container.players.all? { |e| e.tag_bundle.may_be_ibisha? }
              player.piece_box.has_key?(:bishop)
            end
          else
            player.tag_bundle.include?("角換わり")
          end
        end

        def general_tag
          @general_tag ||= yield_self do
            if false
              str = king_soldier.left_or_right == :left ? :"居飛車" : :"振り飛車"
            else
              str = player.tag_bundle.ibisha_or_furibisha
            end
            :"#{str}穴熊"
          end
        end

        # 穴熊玉を中心とした外周とその外周に存在する金銀の個数
        # 金銀の個数 = 銀以上の価値のある駒の個数
        # 個数0枚 = 玉しかいない
        def kin_gin_count
          @kin_gin_count ||= yield_self do
            V.anaguma_vectors(king_soldier.left_or_right).count do |e|
              if v = king_soldier.relative_move_to(e)
                if s = board[v]
                  if own?(s)
                    if s.piece.hisyakaku && s.normal?
                      # 飛角は除く。そうしないと77角を置いた状態の片穴熊が三枚穴熊になってしまう。
                    else
                      s.abs_weight >= min_score
                    end
                  end
                end
              end
            end
          end
        end

        # 自玉
        def king_soldier
          @king_soldier ||= player.king_soldier
        end

        # 銀以上とする価値
        def min_score
          @min_score ||= Piece[:silver].basic_weight
        end
      end
    end
  end
end
