require "sinatra"
get "/" do
  [
    escape_html(ENV.inspect),
    escape_html(env.inspect),
  ].join("<hr>")
end
