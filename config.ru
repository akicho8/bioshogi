# # 環境確認用
# require "./hello"
# run Sinatra::Application

# こっちにこうかいてもいい？
# require "bundler"
# Bundler.require(:default, :brawser_env)

# アプリ起動用
require "./brawser/brawser"

require "rack/contrib"
use Rack::Runtime
use Rack::ProcTitle

run Brawser
