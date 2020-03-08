require "./example_helper"

tp TacticInfo.all_elements.collect { |e|
  { key: e.name, urls: e.urls}
}
