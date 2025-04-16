require "./setup"

info = Parser.parse(<<~EOT)
後手の持駒：金
+------+
|v金v玉|
| 金 金|
+------+
先手の持駒：金2銀
EOT
info.to_yomiage_list            # =>
tp info.to_yomiage_list

info = Parser.parse("position sfen 9/9/9/9/9/9/9/9/9 b - 1")
info.to_yomiage_list            # =>
tp info.to_yomiage_list

# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:354:in `rescue in block in set_autoloads_in_dir': wrong constant name BreakbeatLongStrip.band inferred by Zeitwerk::GemInflector from directory (Zeitwerk::NameError)
# ~>
# ~>   /Users/ikeda/src/bioshogi/lib/bioshogi/assets/audios/breakbeat_long_strip.band
# ~>
# ~> Possible ways to address this:
# ~>
# ~>   * Tell Zeitwerk to ignore this particular directory.
# ~>   * Tell Zeitwerk to ignore one of its parent directories.
# ~>   * Rename the directory to comply with the naming conventions.
# ~>   * Modify the inflector to handle this case.
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:330:in `block in set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:26:in `block in ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `each_child'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:329:in `set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:76:in `block in on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:75:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:75:in `on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:60:in `block in on_dir_autoloaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:46:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:46:in `on_dir_autoloaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/kernel.rb:31:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:95:in `const_get'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:95:in `cget'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:238:in `block (2 levels) in eager_load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:26:in `block in ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `each_child'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:226:in `block in eager_load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:211:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:211:in `eager_load'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi.rb:48:in `<top (required)>'
# ~> 	from /Users/ikeda/src/bioshogi/workbench/setup.rb:2:in `require'
# ~> 	from /Users/ikeda/src/bioshogi/workbench/setup.rb:2:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~> 	from -:1:in `<main>'
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:89:in `const_defined?': wrong constant name BreakbeatLongStrip.band (NameError)
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:89:in `cdef?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:66:in `strict_autoload_path'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:449:in `autoload_path_set_by_me_for?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:372:in `autoload_subdir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:347:in `block in set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:26:in `block in ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `each_child'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:329:in `set_autoloads_in_dir'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:76:in `block in on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:75:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:75:in `on_namespace_loaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:60:in `block in on_dir_autoloaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:46:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/callbacks.rb:46:in `on_dir_autoloaded'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/kernel.rb:31:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:95:in `const_get'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:95:in `cget'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:238:in `block (2 levels) in eager_load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:26:in `block in ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `each_child'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader/helpers.rb:18:in `ls'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:226:in `block in eager_load'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:211:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/zeitwerk-2.5.3/lib/zeitwerk/loader.rb:211:in `eager_load'
# ~> 	from /Users/ikeda/src/bioshogi/lib/bioshogi.rb:48:in `<top (required)>'
# ~> 	from /Users/ikeda/src/bioshogi/workbench/setup.rb:2:in `require'
# ~> 	from /Users/ikeda/src/bioshogi/workbench/setup.rb:2:in `<top (required)>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/site_ruby/2.6.0/rubygems/core_ext/kernel_require.rb:85:in `require'
# ~> 	from -:1:in `<main>'
