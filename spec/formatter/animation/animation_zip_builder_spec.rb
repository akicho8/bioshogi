require "spec_helper"

module Bioshogi
  module Formatter
    module Animation
      describe AnimationZipBuilder, animation: true do
        it "zip" do
          info = Parser.parse("position startpos moves 7g7f 8c8d")
          bin = info.to_animation_zip(cover_text: "(cover_text)", basename_format: "xxx%d")
          filename = Pathname(Tempfile.create(["", ".zip"], &:path))
          filename.write(bin)
          puts `unzip -l #{filename}` if $0 == "-"
          Zip::InputStream.open(StringIO.new(bin)) do |zis|
            assert { zis.get_next_entry.name == "cover.png" }
            assert { zis.get_next_entry.name == "xxx0.png"  }
            assert { zis.get_next_entry.name == "xxx1.png"  }
          end
        end
      end
    end
  end
end
# ~> <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require': cannot load such file -- bioshogi (LoadError)
# ~> Did you mean?  bioshogi_spec
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from /Users/ikeda/src/bioshogi/spec/spec_helper.rb:2:in '<top (required)>'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from <internal:/opt/rbenv/versions/3.4.2/lib/ruby/site_ruby/3.4.0/rubygems/core_ext/kernel_require.rb>:136:in 'Kernel#require'
# ~> 	from -:1:in '<main>'
