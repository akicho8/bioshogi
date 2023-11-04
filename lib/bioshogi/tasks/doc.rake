task :doc => "doc:generate"

namespace :doc do
  desc "[g] generate README.md"
  task "generate" do
    system "sh", "-vec", <<~EOT, exception: true
saferenum -x doc
source2md generate --xmp-out-exclude -o NEW_README.md doc/0*
EOT
  end
end
