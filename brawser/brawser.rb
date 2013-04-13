# -*- coding: utf-8 -*-
# WEBインタフェース

require "bundler"
Bundler.require(:default, :brawser_env)
Bushido::XtraPattern.reload_all

class MediatorDecorator < SimpleDelegator
  def to_html_board(type = :default)
    rows = Bushido::Position::Vpos.ridge_length.times.collect do |y|
      tds = Bushido::Position::Hpos.ridge_length.times.collect do |x|
        tag_class = []
        cell = ""
        if soldier = board.surface[[x, y]]
          tag_class << soldier.player.location.key
          cell = soldier.piece_current_name
        end
        if kif_log = kif_logs.last
          if kif_log.point == Bushido::Point[[x, y]]
            tag_class << "last_point"
          end
          if kif_log.origin_point == Bushido::Point[[x, y]]
            tag_class << "last_point2"
          end
        end
        "<td class=\"#{tag_class.join(' ')}\">#{cell}</td>"
      end
      "<tr>#{tds.join("\n")}</tr>"
    end
    "<table class=\"board #{type}\">\n#{rows.join("\n")}\n</table>"
  end
end

redis_args = {}
if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis_args = {:host => uri.host, :port => uri.port, :password => uri.password}
end
REDIS = Redis.new(redis_args)
REDIS.flushdb

class Brawser < Sinatra::Base
  register Sinatra::MultiRoute

  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    set :server, :puma
  end

  set :sessions, true

  get "/stylesheet.css" do
    # FIXME: cache
    sass :stylesheet, Compass.sass_engine_options
  end

  get "/slim" do
    slim :slim_index
  end

  route :get, :post, "/" do
    @session_id = env["rack.session"]["session_id"]

    if !params[:reset].nil? || REDIS.get(@session_id).nil?
      mediator = Bushido::Mediator.start
      mediator.piece_plot
      REDIS.set(@session_id, Marshal.dump(mediator))
    end

    dump = Marshal.load(REDIS.get(@session_id))
    @mediator = Bushido::Mediator.from_dump(dump)

    if params[:location].nil? || @mediator.current_player.location.key.to_s == params[:location]
      if params[:way].present?
        @mediator.execute(params[:way])
      end
      if params[:auto1].present?
        eval_list = @mediator.current_player.brain.eval_list
        if info = eval_list.first
          @mediator.execute(info[:way])
        end
      end
      if params[:auto2].present?
        if way = @mediator.current_player.generate_way.presence
          @mediator.execute(way)
        end
      end
    end

    REDIS.set(@session_id, Marshal.dump(@mediator))

    @bar_colors = {Bushido::Location[:white] => "bar-danger"}
    @eval_results = Bushido::Location.inject({}){|hash, loc|hash.merge(loc => @mediator.player_at(loc).evaluate)}
    total = @eval_results.values.reduce(:+)
    @scores = @eval_results.inject({}){|h, (k, v)|h.merge(k => (v * 100.0 / total).round)}

    haml :show
  end

  get "/tactics" do
    if Sinatra::Base.environment == :development
      Bushido::XtraPattern.reload_all
    end

    if params[:id]
      @pattern = Bushido::XtraPattern.list[params[:id].to_i]
      if @pattern
        @frames = Bushido::HybridSequencer.execute(@pattern)
      end
    end
    haml :tactics
  end

  get "/kif_form" do
    @pattern_body_default = %(
board <<-BOARD
  ９ ８ ７ ６ ５ ４ ３ ２ １
+---------------------------+
| ・ ・ ・ ・ ・ ・ ・v桂v香|一
| ・ ・ ・ ・ ・v銀v金v角 ・|二
| ・ ・ ・ ・ ・v歩v歩 ・v歩|三
| ・ ・ ・ ・ ・ ・ ・ ・ ・|四
| ・ ・ ・ ・ ・ ・ ・ ・ ・|五
| ・ ・ ・ ・ ・ ・ ・ ・ ・|六
| ・ ・ ・ ・ ・ ・ 歩 ・ 歩|七
| ・ ・ ・ ・ ・ ・ ・ 飛 ・|八
| ・ ・ ・ ・ ・ ・ ・ 桂 香|九
+---------------------------+
BOARD
pieces "先手" => "歩1"
auto_flushing {
  push {
    comment "成功するパターン"
    mov "▲２四歩"
    mov "△３一角"
    mov "▲２三歩成"
  }
  push {
    comment "最初に戻って失敗するパターン"
    mov "▲２三歩"
    mov "△３一角"
    mov "▲２二歩成"
    mov "△２二角"
  }
})
    if params[:kif_title].present?
      @pattern = Bushido::XtraPattern.new({
          :title => params[:kif_title],
          :dsl => Bushido::KifuDsl.define(params){|params|eval(params[:kif_body])},
        })
      @frames = Bushido::HybridSequencer.execute(@pattern)
    else
      params[:kif_title] ||= "垂らしの歩"
      params[:kif_body] ||= @pattern_body_default
    end
    haml :kif_form
  end

  get "/tactics_and_enclosure" do
    if Sinatra::Base.environment == :development
      Bushido::Stock.reload_all
    end
    haml :tactics_and_enclosure
  end

  get "/learn_board_points" do
    session[:test_count] ||= 0
    session[:start_time] ||= Time.now
    unless params[:count]
      session[:test_count] = 0
      session[:start_time] = Time.now
    end
    count = params[:count].to_i
    session[:test_count] += count
    begin
      @mediator = Bushido::Mediator.start
      count.times do
        mini_soldier = Bushido::MiniSoldier[:point => Bushido::Point.to_a.sample, :piece => Bushido::Piece.to_a.sample, :promoted => [true, false].sample]
        @mediator.players.sample.initial_soldiers(mini_soldier, :from_piece => false)
      end
    rescue Bushido::NotPutInPlaceNotBeMoved, Bushido::NotPromotable, Bushido::PieceAlredyExist => error
      retry
    end
    haml :learn_board_points
  end

  get "/basic_format_form" do
    if params[:body].present?
      @pattern = Bushido::XtraPattern.new({
          :title => params[:title],
          :dsl => Bushido::KifuDsl.define(params){|params|
            board "平手"
            auto_flushing
            mov params[:body]
          },
        })
      @frames = Bushido::HybridSequencer.execute(@pattern)
    else
      if Sinatra::Base.environment == :development
        params[:body] ||= "▲７六歩 △３四歩 ▲２六歩"
        # params[:title] ||= ""
      end
    end
    haml :basic_format_form
  end

  error do
    @error = env["sinatra.error"]
    haml :error
  end

  helpers do
    def bar(name)
      "#{name}bar"
    end
  end
end
