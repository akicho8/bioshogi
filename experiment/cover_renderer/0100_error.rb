require "../setup"

CoverRenderer.new(text: "🦐").display rescue $! # => #<ArgumentError: 絵文字と思われる画像化できない文字が含まれています : "🦐">
