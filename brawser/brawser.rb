# WEBインタフェース

require "bundler/setup"

require "active_support/core_ext/array/conversions"

Warabi::XtraPattern.reload_all

# for /swars_skills
# require 'active_support'
# require 'active_support/core_ext/object/to_json'
require "warabi/contrib/other_files/swars_skills"

require "sinatra/json"
require "open-uri"

class MediatorDecorator < SimpleDelegator
  def to_html_board(type = :default)
    rows = Warabi::OnePlace::Xplace.dimension.times.collect do |y|
      tds = Warabi::OnePlace::Yplace.dimension.times.collect do |x|
        tag_class = []
        cell = ""
        if soldier = board.surface[[x, y]]
          tag_class << soldier.player.location.key
          cell = soldier.any_name
        end
        if hand_log = hand_logs.last
          if hand_log.place_to == Warabi::Place[[x, y]]
            tag_class << "last_place"
          end
          if hand_log.place_from == Warabi::Place[[x, y]]
            tag_class << "last_place2"
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
  redis_args = {host: uri.host, port: uri.port, password: uri.password}
end
REDIS = Redis.new(redis_args)
REDIS.flushdb

class Brawser < Sinatra::Base
  helpers Sinatra::JSON
  register Sinatra::MultiRoute

  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    set :server, :puma
  end

  set :sessions, true

  get "/:name.css" do
    sass params[:name].to_sym, Compass.sass_engine_options
  end

  get "/:name.js" do
    coffee params[:name].to_sym
  end

  get "/slim" do
    slim :slim_index
  end

  route :get, :post, "/" do
    @session_id = env["rack.session"]["session_id"]

    if !params[:reset].nil? || REDIS.get(@session_id).nil?
      mediator = Warabi::Mediator.start
      REDIS.set(@session_id, Marshal.dump(mediator))
    end

    dump = Marshal.load(REDIS.get(@session_id))
    @mediator = Warabi::Mediator.from_dump(dump)
    # @mediator = dump

    if params[:location].nil? || @mediator.current_player.location.key.to_s == params[:location]
      if params[:hand].present?
        @mediator.execute(params[:hand])
      end
      # if params[:think_put].present?
      #   fast_score_list = @mediator.current_player.brain.fast_score_list
      #   if info = fast_score_list.first
      #     @mediator.execute(info[:hand])
      #   end
      # end
      if params[:think_put_lv].present?
        @runtime = Time.now
        @think_result = @mediator.current_player.brain.diver_dive(:depth_max => params[:think_put_lv].to_i)
        @runtime = Time.now - @runtime
        input = Warabi::InputParser.slice_one(@think_result[:hand])[:input]
        @mediator.execute(input)
      end
      if params[:random_put].present?
        if hand = @mediator.current_player.brain.lazy_all_hands.sample.presence
          @mediator.execute(hand)
        end
      end
    end

    REDIS.set(@session_id, Marshal.dump(@mediator))

    # 評価バー
    @score_bars = @mediator.players.collect do |player|
      {
        :location => player.location,
        :score    => player.evaluate,
        :rate     => player.score_percentage,
        :style    => {:white => "bar-danger"}[player.location.key],
      }
    end

    haml :show
  end

  get "/tactics" do
    if Sinatra::Base.environment == :development
      Warabi::XtraPattern.reload_all
    end

    if params[:id]
      @pattern = Warabi::XtraPattern.list[params[:id].to_i]
      if @pattern
        @snapshots = Warabi::HybridSequencer.execute(@pattern)
      end
    end
    haml :tactics
  end

  get "/dsl_form" do
    @pattern_body_default = %(
board <<-EOT
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
EOT
pieces "▲" => "歩1"
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
      @pattern = Warabi::XtraPattern.new({
          title: params[:kif_title],
          notation_dsl: Warabi::NotationDsl.define(params){|params|eval(params[:kif_body])},
        })
      @snapshots = Warabi::HybridSequencer.execute(@pattern)
    else
      params[:kif_title] ||= "垂らしの歩"
      params[:kif_body] ||= @pattern_body_default
    end
    haml :dsl_form
  end

  get "/tactics_and_enclosure" do
    haml :tactics_and_enclosure
  end

  get "/simple_kifu_form" do
    if params[:body].present?
      @pattern = Warabi::XtraPattern.new({
          title: params[:title],
          notation_dsl: Warabi::NotationDsl.define(params){|params|
            board "平手"
            auto_flushing
            mov params[:body]
          },
        })
      @snapshots = Warabi::HybridSequencer.execute(@pattern)
    else
      if Sinatra::Base.environment == :development
        params[:body] ||= "▲７六歩 △３四歩 ▲２六歩"
        # params[:title] ||= ""
      end
    end
    haml :simple_kifu_form
  end

  post "/standard_kifu_form" do
    kifu_form_action_shared
    haml :standard_kifu_form
  end

  get "/standard_kifu_form" do
    kifu_form_action_shared
    haml :standard_kifu_form
  end

  get "/kifu_url_form" do
    kifu_form_action_shared
    haml :kifu_url_form
  end

  def kifu_form_action_shared
    if params[:url].present?
      params[:body] = URI(params[:url]).read.to_s.toutf8
    end
    if params[:body].present?
      @kif_info = Warabi::Parser.parse(params[:body])
      @pattern = Warabi::XtraPattern.new({
          title: params[:title],
          notation_dsl: Warabi::NotationDsl.define(@kif_info){|kif_info|
            board "平手"
            auto_flushing
            kif_info.move_infos.each{|move_info|
              comment move_info[:comments]
              mov move_info[:mov]
            }
          },
        })
      @snapshots = Warabi::HybridSequencer.execute(@pattern)
    end
  end

  get "/swars_skills.?:format?" do
    @swars_skills = SwarsSkills

    @columns_hash = {
      :image_url             => {:label => "画像"},
      :code                  => {:label => "Code"},
      :name                  => {:label => "技名"},
      :iname                 => {:label => "技名"},
      :rarity                => {:label => "レア度"},
      :rarity_stars          => {:label => "レア度"},
      :uu_count              => {:label => "UU"},
      :count                 => {:label => "回数"},
      :description           => {:label => "コメント"},
      :game_url              => {:label => "対戦"},
      :ranking_url           => {:label => "ランキング"},
      :xs_image_url          => {:label => "画像(小)"},
      :type                  => {:label => "Type"},
      :key                   => {:label => "キー"},
      :page                  => {:label => "Page"},
      :rate                  => {:label => "人気"},
      :name_with_description => {:label => "技"},
      :dan_avg               => {:label => "棋力"},
    }

    @types_hash = {
      :t_a => {:label => "技",         :columns => %w(name_with_description)},
      # :t_b => {:label => "シンプル",   :columns => %w(iname rate rarity code)},
      :t_c => {:label => "統計",       :columns => %w(iname dan_avg rate uu_count count rarity code)},
      # :t_e => {:label => "ランキング", :columns => %w(iname ranking_url code)},
      :t_d => {:label => "画像",       :columns => %w(image_url)},
    }

    params[:type] ||= @types_hash.keys.first.to_s
    @columns ||= @types_hash[params[:type].to_sym][:columns]
    if only = params[:only]
      @columns = only.scan(/\w+/)
    elsif except = params[:except]
      @columns = @columns - except.scan(/\w+/)
    end

    case params[:format]
    when "json"
      json @swars_skills
    when "xml"
      content_type :xml
      @swars_skills.to_xml
    else
      haml :swars_skills
    end
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
