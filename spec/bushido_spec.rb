# -*- coding: utf-8 -*-

require "spec_helper"

module Bushido
  describe Bushido do
    it do
      @board = Board.new
      @players = []
      @players << Player.create2(:black, @board)
      @players << Player.create2(:white, @board)
      @players.each(&:piece_plot)
      # puts @board.to_s
      @players[0].move_to("7七", "7六")
      # puts @board.to_s
      @players[1].move_to("3三", "3四")
      # puts @board.to_s
      @players[0].move_to("8八", "2二")
      # puts @board.to_s

      # p Point.parse("4三").name
      # p Point.parse("４三").name
      # p Point.parse("43").name
      #
      # p Point.parse("4三").to_xy # => [5, 2]
    end

    context "ファイル読み込み" do
      it "できる" do
        Bushido.parse(Pathname(__FILE__).dirname.join("sample1.kif"))
        Bushido.parse(Pathname(__FILE__).dirname.join("sample1.ki2"))
      end
      it "できない" do
        expect { Bushido.parse(Pathname(__FILE__).dirname.join("sample1.bin")) }.to raise_error(FileFormatError)
      end
    end
  end
end
