# -*- coding: utf-8 -*-
source "https://rubygems.org"
gemspec
gem "rain_table", git: "https://github.com/akicho8/rain_table.git" # gemspec で効かないので

# web i/f 用なんだけどここには書きたくなかった
group :brawser_env do
  gem "sinatra"
  gem "sinatra-contrib"
  gem "compass"      # for stylesheet.css
  gem "sass"         # for stylesheet.css
  gem "redis"        # でかいセッション保持用
  gem "rack-contrib" # Rack::Runtime 等
  gem "haml"         # for view
  gem "hpricot"      # for html2haml

  gem "slim"
  gem "puma"
end

group :development do
  gem "foreman"
  # gem "sinatra-contrib", github: "sinatra/sinatra-contrib", require: "sinatra/reloader"
end
