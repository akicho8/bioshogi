require "./setup"
require "json"

info = Parser.parse("position startpos moves 7i6h")
info.formatter.container.to_short_sfen # => "sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL w - 2"

# ▼サーバーレス将棋 Ai ☖ - Qiita
# https://qiita.com/na-o-ys/items/b04ce27732c82b6beb9b

require "faraday"
url = "https://17xn1ovxga.execute-api.ap-northeast-1.amazonaws.com/production/gikou?byoyomi=10000&dimension=#{URI.escape(info.formatter.container.to_short_sfen)}"
url # => "https://17xn1ovxga.execute-api.ap-northeast-1.amazonaws.com/production/gikou?byoyomi=10000&dimension=sfen%20lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL%20w%20-%202"
response = Faraday.get(url)
response.status                 # => 502
JSON.parse(response.body)       # => {"message"=>"Internal server error"}
# ~> -:11:in `<main>': warning: URI.escape is obsolete
# ~> !XMP1513426487_63066_801239![2] => String "https://17xn1ovxga.execute-api.ap-northeast-1.amazonaws.com/production/gikou?byoyomi=10000&dimension=sfen%20lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B1S3R1/LN1GKGSNL%20w%20-%202"
# ~> info
# ~> _xmp_1513426487_63066_969774
# ~> url
# ~> response
# ~> !XMP1513426487_63066_801239![3] => Integer 502
# ~> info
# ~> _xmp_1513426487_63066_969774
# ~> url
# ~> response
# ~> !XMP1513426487_63066_801239![4] => Hash {"message"=>"Internal server error"}
# ~> info
# ~> _xmp_1513426487_63066_969774
# ~> url
# ~> response
