# -*- coding: utf-8 -*-

# # 環境確認用
# require "./hello"
# run Sinatra::Application

# アプリ起動用
require "./battler/battler"

require "rack/contrib"
use Rack::Runtime
use Rack::ProcTitle

run Battler
