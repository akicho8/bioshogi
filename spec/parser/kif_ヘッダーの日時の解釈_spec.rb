require "spec_helper"

module Bioshogi
  describe "日時" do
    it do
      assert { Parser.parse("#comment\n開始日時：2000年01月02日(金) 01：02：03").header.to_h           == {"開始日時"=>"2000/01/02 01:02:03" } }
      assert { Parser.parse("　　#comment\n　　\t開始日時：2000年01月02日(金) 01：02：03").header.to_h == {"開始日時"=>"2000/01/02 01:02:03" } }
      assert { Parser.parse("#開始日時：2000年01月02日(金) 01：02：03").header.to_h                    == {                                  } }
      assert { Parser.parse("開始日時：2000年01月02日(金) 01：02：03").header.to_h                     == {"開始日時"=>"2000/01/02 01:02:03" } }
      assert { Parser.parse("開始日時：2000/01/02 01:02:03").header.to_h                               == {"開始日時"=>"2000/01/02 01:02:03" } }
      assert { Parser.parse("放送日：2000/01/02 01:02:03").header.to_h                                 == {"放送日"=>"2000/01/02 01:02:03"   } }
      assert { Parser.parse("放送日：2000-01-02 01:02:03").header.to_h                                 == {"放送日"=>"2000/01/02 01:02:03"   } }
      assert { Parser.parse("放送日：2000-01-02 01:02:61").header.to_h                                 == {"放送日"=>"2000-01-02 01:02:61"   } }
    end
  end
end
