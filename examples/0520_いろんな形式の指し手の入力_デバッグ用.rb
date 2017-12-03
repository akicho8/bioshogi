require "./example_helper"

mediator = Mediator.new
mediator.board_reset
list = ["7776FU","8384FU","7978GI","3334FU","7877GI","8485FU","2726FU","3142GI","6978KI","4132KI","3948GI","7162GI","5756FU","5354FU","5969OU","5141OU","2625FU","4233GI","4857GI","6253GI","3736FU","6152KI","4958KI","7374FU","4746FU","4344FU","2937KE","5364GI","6766FU","5243KI","5847KI","2231KA","5768GI","7475FU","6867GI","7576FU","6776GI","0075FU","7667GI","6473GI","2858HI","7374GI","5655FU","5455FU","5855HI","3142KA","5558HI","4131OU","8879KA","0054FU","7968KA","3122OU","6979OU","9394FU","1716FU","1314FU","6756GI","7576FU","7776GI","7475GI","7675GI","4275KA","7877KI","7584KA","0076GI","6364FU","7978OU","8272HI","0075FU","8493KA","9796FU","0084GI","7667GI","8475GI","0076FU","7584GI","4645FU","8586FU","8786FU","0085FU","2524FU","2324FU","0025FU","8586FU","2524FU","8485GI","5828HI","0026FU","2826HI","9371KA","2628HI","0026FU","0084FU","7282HI","1615FU","1415FU","3725KE","8284HI","0012FU","1112KY","0013FU","2113KE","2533KE","2233OU","8997KE","0075KE","9785KE","8687FU","7787KI","7587KE","7887OU","0086FU","6886KA","8485HI","0074GI","8584HI","0085GI","8482HI","0083FU","8292HI","0014FU","1325KE","2826HI","3324OU","8668KA","2414OU","0024KE","3233KI","2412KE"]
list.each do |e|
  p e
  mediator.execute(e)
  p mediator.turn_info.counter
  pp [e, mediator.hand_logs.last.to_s_kif]
end
# ~> /Users/ikeda/src/bushido/lib/bushido.rb:39:in `require_relative': /Users/ikeda/src/bushido/lib/bushido/player.rb:352: syntax error, unexpected ',', expecting keyword_end (SyntaxError)
# ~>         errors << DoublePawnError, "二歩 (#{s.mark_with_formal
# ~>                              ^
# ~> 	from /Users/ikeda/src/bushido/lib/bushido.rb:39:in `<top (required)>'
# ~> 	from /Users/ikeda/src/bushido/examples/example_helper.rb:2:in `require'
# ~> 	from /Users/ikeda/src/bushido/examples/example_helper.rb:2:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.4.1/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
# ~> 	from -:1:in `<main>'
