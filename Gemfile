source "https://rubygems.org"
gemspec

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
  gem "builder"      # for active_support の to_xml ?
  gem "multi_json"   # for sinatra/json ?

  gem 'coffee-script'
  gem 'execjs'

  gem "slim"
  gem "puma"
end

# なんだこれ？
group :development do
  gem "foreman"
  # gem "sinatra-contrib", github: "sinatra/sinatra-contrib", require: "sinatra/reloader"
end
