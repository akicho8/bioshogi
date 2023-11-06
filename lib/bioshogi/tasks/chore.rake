desc "bundle update (alias)"
task :bu => :bundle_update

desc "bundle update"
task :bundle_update do
  system "bundle update"
  system "cd experiment && bundle update"
end
