module Bioshogi
  # kif, ki2, bod 変換の共通処理
  concern :KakinokiBuilder do
    attr_accessor :parser
    attr_accessor :params
    attr_accessor :header

    class_methods do
      def default_params
        super.merge({
            :has_header => true,
            :has_footer => true,
          })
      end
    end

    def initialize(parser, params = {})
      @parser = parser
      @params = self.class.default_params.merge(params)
      # Assertion.assert { parser.header.object_id != @header.object.object_id }
    end

    def to_s
      build_before
      @parser.xcontainer_run_once
      @header = @parser.header.clone

      out = []

      if @params[:has_header]
        if @header.present?
          out << header_part_string
        end
      end

      out << body_header
      out << body_hands

      if @params[:has_footer]
        out << footer_content
        if s = @parser.judgment_message
          out << "#{s}\n"
        end
        if s = illegal_judgement_message
          out << s
        end
        out << @parser.error_message_part
      end

      out.join
    end

    private

    def build_before
    end

    def body_header
      "\n"
    end

    def body_hands
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def footer_content
    end

    def header_part_string
      m = @parser.initial_xcontainer

      if e = m.board.preset_info
        # 手合割がわかる場合
        @header["手合割"] = e.name
        mochigoma_delete_if_blank # 手合割がわかるとき持駒が空なら消す
        raw_header_part_string
      else
        # ".*の持駒" を消してBODを埋める
        mochigoma_delete_force
        raw_header_part_string + m.to_bod(display_turn_skip: true, compact: true)
      end
    end

    def raw_header_part_hash
      header.object.collect { |key, value|
        if value
          if e = CsaHeaderInfo[key]
            if e.as_kif
              value = e.instance_exec(value, &e.as_kif)
            end
          end
          [key, value]
        end
      }.compact.to_h
    end

    def raw_header_part_string
      raw_header_part_hash.collect { |key, value| "#{key}：#{value}\n" }.join
    end

    def mochigoma_delete_force
      Location.call_names.each do |e|
        header.delete("#{e}の持駒")
      end
    end

    def mochigoma_delete_if_blank
      Location.call_names.each do |e|
        key = "#{e}の持駒"
        if v = @header[key]
          if v.blank? || v == "なし"
            @header.delete(key)
          end
        end
      end
    end

    # 将棋倶楽部24の棋譜だけに存在する、自分の手番で相手が投了したときの文言に対応する
    # "*" のあとにスペースを入れると、激指でコメントの先頭にスペースが入ってしまうため、仕方なくくっつけている
    def illegal_judgement_message
      if @parser.last_action_params
        v = @parser.last_action_params[:last_action_key]
        if !LastActionInfo[v]
          "*#{v}\n"
        end
      end
    end

    # 全角対応 ljust
    #
    #  mb_ljust("あ", 3)  # => "あ "
    #  mb_ljust("1", 3)   # => "1  "
    #  mb_ljust("123", 3) # => "123"
    #
    def mb_ljust(str, width)
      n = width - str.encode("EUC-JP").bytesize
      if n < 0
        n = 0
      end
      str + " " * n
    end
  end
end
