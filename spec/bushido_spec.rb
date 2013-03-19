# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Bushido do
    describe "棋譜ファイルの読み込み" do
      it "できる" do
        Bushido.parse_file(Pathname(__FILE__).dirname.join("sample1.kif"))
        Bushido.parse_file(Pathname(__FILE__).dirname.join("sample1.ki2"))
      end
      it "できない" do
        proc { Bushido.parse_file(Pathname(__FILE__).dirname.join("sample1.bin")) }.must_raise Errno::ENOENT
      end
    end

    describe "棋譜コンテンツのパース" do
      it "できる" do
        Bushido.parse("手数----指手---------消費時間--") # kif
        Bushido.parse("\n\n")                            # ki2
      end
      it "できない" do
        proc { Bushido.parse(nil) }.must_raise Bushido::FileFormatError
        proc { Bushido.parse("")  }.must_raise Bushido::FileFormatError
      end
    end
  end
end
