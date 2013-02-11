# -*- coding: utf-8 -*-
source :rubygems
gemspec
gem "rain_table", :git => "https://github.com/akicho8/rain_table.git" # gemspec で効かないので

# web i/f 用なんだけどここには書きたくなかった
group :webif do
  gem "sinatra"
  gem "sinatra-contrib"
  gem "compass"      # for stylesheet.css
  gem "sass"         # for stylesheet.css
  gem "redis"        # でかいセッション保持用
  gem "rack-contrib" # Rack::Runtime 等
  gem "haml"         # for view
  gem "hpricot"      # for html2haml
end
