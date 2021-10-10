# # 環境確認用
# require "./hello"
# run Sinatra::Application

# こっちにこうかいてもいい？
# require "bundler"
# Bundler.require(:default, :browser_env)

# アプリ起動用
require "./browser/browser"

require "rack/contrib"
use Rack::Runtime
use Rack::ProcTitle

run Browser
