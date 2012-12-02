# -*- coding: utf-8 -*-
require_relative "../spec_helper"

describe Bushido do
  it do
    module Bushido
      @field = Field.new
      @players = []
      @players << Player.new("先手", @field, :kotti)
      @players << Player.new("後手", @field, :atti)
      @players.each(&:setup)
      @field.to_s
      @players[0].move_to("7七", "7六")
      @field.to_s
      @players[1].move_to("3三", "3四")
      @field.to_s
      @players[0].move_to("8八", "2二")
      @field.to_s
    end
  end
end
