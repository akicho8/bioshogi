require "#{__dir__}/setup"

class App
  ANIMATION_OPTIONS = {
    :page_duration   => 0.5,
    :begin_pages     => nil,
    :begin_duration  => 1.0,
    :end_pages       => nil,
    :end_duration    => 1.0,
    :turn_embed_key  => "is_turn_embed_on",
    :audio_theme_key => :is_audio_theme_none,
    :color_theme_key => :is_color_theme_modern,
    # :width           => 854,
    # :height          => 480,
    :width           => 1920,
    :height          => 1080,
  }

  def call
    # { key: "is_rect_size_854x480",   name: "854x480",        aspect_ratio: "16:9",   icon: "youtube", type: "is-danger", recommend: "◎", general_name: "FULL HD",     width: 854, height: 480,    type: "is-primary", environment: ["development", "staging", "production"], message: "低画質",        },
    # { key: "is_rect_size_1280x720",  name: "1280x720",       aspect_ratio: "16:9",   icon: "youtube", type: "is-danger", recommend: "◎", general_name: "HD",          width: 1280, height:  720,  type: "is-primary", environment: ["development", "staging", "production"], message: "普通画質",      },
    # { key: "is_rect_size_1920x1080", name: "1920x1080",      aspect_ratio: "16:9",   icon: "youtube", type: "is-danger", recommend: "◎", general_name: "FULL HD",     width: 1920, height: 1080,  type: "is-primary", environment: ["development", "staging", "production"], message: "高画質 (推奨)",        },
    Pathname("#{__dir__}/.tmp").mkpath

    options = {
      :generate => true,
    }

    if options[:generate]
      items.each do |e|
        puts "[#{e.index}] #{e.basename}"
        info = Parser.parse(e.file.read)
        options = ANIMATION_OPTIONS.merge(cover_text: e.no_desc)
        bin = info.to_animation_mp4(options)
        Pathname(".tmp/output#{e.index}.mp4").write(bin)
      end

      body = items.collect { |e, i| "file 'output#{e.index}.mp4'" + "\n" }.join
      Pathname(".tmp/filelist.txt").write(body)
      system "ffmpeg -f concat -safe 0 -i .tmp/filelist.txt -c copy -y _output.mp4"
      chrome "_output.mp4"
    end

    tp items.collect(&:to_h)
    Pathname(__dir__).join("index.org").write(items.collect(&:to_h).to_t)
  end

  def items
    items = Pathname(__dir__).glob("石田流攻め筋集/0*")

    # items = items.reverse.take(5)
    # items = items.find_all { |e| e.to_s.include?("0160_対金無双_端攻め_先に85桂") }

    items.collect.with_index do |e, i|
      basename = e.basename.to_s
      file = e.join("1.kif")
      description = e.join("description.txt").read.strip
      Item.new(
        :index       => i,
        :basename    => basename,
        :description => description,
        :file        => e.join("1.kif"),
        )
    end
  end

  Item = Data.define(:index, :basename, :description, :file) do
    def no_desc
      [index.next, description].join(".")
    end
    # def inspect
    #   puts "[#{i.next}/#{items.size}] [#{basename}] [#{description.squish}]"
  end
end

App.new.call
