# 画像のプレビュー表示
#
# foo.png = サムネ画像
# bar.png = でかい画像
# と仮定して──
#
# foo.png の上にマウスを乗せると bar.png を表示したい
#
#   <a href="bar.png" class="image_preview"><img src="foo.png" /></a>
#   $(".image_preview").image_preview()
#
# bar.png は横800もあるのでできれば横320にして表示したい
#
#   <a href="bar.png" class="image_preview"><img src="foo.png" /></a>
#   $(".image_preview").image_preview(width: 320)
#
# クリックしたときのリンク先は画像ではなく別のページしたい
#
#   <a href="bar.html" class="image_preview" rel="bar.png"><img src="foo.png" /></a>
#   $(".image_preview").image_preview()
#
# マウスを乗せる部分は別に画像でなくてもよい
#
#   <a href="bar.png" class="image_preview">foo.png</a>
#   $(".image_preview").image_preview()
#
# あらかじめaで囲むのが面倒だし、リンクで飛ばしたくないし、クラス名をつけるのも面倒
#
#   <img src="foo.png" rel="bar.png" />
#   $("img[rel]").image_preview()
#
# bar.png の上にマウスを乗せると bar.png を原寸表示したい
#
#   <img src="bar.png" width="16" />
#   $("img").image_preview()
#
$.image_preview = (target, options = {}) ->
  default_options =
    fade_in_delay: 1000.0 / 60 * 15 # フェイドインしてくるときのスピード
    mousemove: true                 # マウスと連動して動かすか？
    offset_x: 20                    # マウスからの距離(X)
    offset_y: -4                    # マウスからの距離(Y)
    float_dom_id: "image_float_box" # 浮ぶDOMのid
    tooltip_disable: true           # title属性の内容がホバーして画像の上に乗ってしまうのを防ぐ？

  options = $.extend(true, {}, default_options, options)

  float_box = null
  save_title = null

  target.hover (e) ->
    # マウスが乗ったとき
    src = $(@).attr("rel") || $(@).attr("href") || $(@).attr("src")

    if options.tooltip_disable
      save_title = $(@).attr("title")
      $(@).removeAttr("title")

    img = $("<img src=\"#{src}\" alt=\"\" />")

    # でかすぎるプレビューを出さないように縦横の片方を設定できるようにする
    if options.width
      img.attr("width", options.width)
    if options.height
      img.attr("height", options.height)

    # bodyの最後に埋め込む
    if false
      # 他のコンテンツを埋め込む場合はdivで囲まないといけない
      $("body").append($("<div id=\"#{options.float_dom_id}\"></div>").html(img))
    else
      img.attr("id", options.float_dom_id)
      $("body").append(img)

    # 浮ぶdivにアクセスしやすくしておく
    float_box = $("##{options.float_dom_id}")

    # マウスのよこに表示
    float_box.css
      left: e.pageX + options.offset_x
      top:  e.pageY + options.offset_y
    .fadeIn(options.fade_in_delay)
  , ->
    # マウスが離れたら消去
    float_box.remove()
    # titleを復元
    if save_title
      target.attr("title", save_title)

  if options.mousemove
    target.mousemove (e) ->
      float_box.css
        left: e.pageX + options.offset_x
        top:  e.pageY + options.offset_y

$.fn.image_preview = (options) ->
  $.image_preview($(@), options)

# #
# # その場で画像ズーム
# #
# # foo.png の上にマウスを乗せると foo.png を拡大するには？
# #
# #   <img src="foo.png" class="toggleable" />
# #   $(".toggleable").image_toggleable()
# #
# $.fn.image_toggleable = (options) ->
#   default_options =
#     original_width: "auto"
#     original_height: "auto"
#     width: 256
#     height: 256
#     has_shift_key: true
#     speed: "normal"
# 
#   options = $.extend(true, {}, default_options, options)
# 
#   $(@).toggle (e) ->
#     if (options.has_shift_key and e.shiftKey) or !options.has_shift_key
#       one_place = $(@).one_place()
#       $(@)
#         .css
#           one_place:"absolute"
#           top: one_place.top
#           left: one_place.left
#         .animate
#           width: options.width
#           height: options.height
#           left: one_place.left - (options.width / 4)
#           top: one_place.top - (options.height / 4)
#         , options.speed
#   , (e) ->
#     $(@)
#       .css
#         width: options.original_width
#         height: options.original_height
#         top: "auto"
#         left: "auto"
#         opacity: 1.0
#         one_place: "static"
#       .show()
# 
# #
# # マウスが乗ったら薄くする
# #
# $.fn.opacity_over = (from = 1.0, to = 0.65, down_speed = "fast", revert_spped = "fast") ->
#   $(@).each ->
#     $(@)
#     # .css
#     #   opacity: from
#     #   filter: "alpha(opacity=#{from * 100})"
#     .hover ->
#       $(@).fadeTo(down_speed, to)
#     , ->
#       $(@).fadeTo(revert_spped, from)
# 
# #
# # 指定のaはクリックするとトップのフレームの location.href を書き換えて移動させる
# #
# # 使い方:
# #   link_to("Google", "http://www.google.co.jp/", :class => "over_iframe")
# #   $("a.over_iframe").over_iframe()
# #
# $.fn.iframe_over_link = ->
#   $(@).click (e) ->
#     top.location.href = $(@).attr("href")
#     e.preventDefault()
#     e.stopPropagation()
#     true
