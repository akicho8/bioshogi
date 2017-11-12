require "./example_helper"

info = Bushido.parse(Pathname("debug.kif"))

out = ""
out << info.header.collect { |key, value| "#{key}：#{value}\n" }.join
out << "\n"
# puts info

mediator = Mediator.start
mediator.piece_plot
info.move_infos.each do |info|
  mediator.execute(info[:input])
end
out << mediator.ki2_hand_logs.group_by.with_index{|_, i|i / 10}.values.collect { |v| v.join(" ") + "\n" }.join
out << mediator.last_message
puts out

# ~> /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- ./example_helper (LoadError)
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
# ~> 	from -:1:in `<main>'
