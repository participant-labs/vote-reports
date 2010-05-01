begin
  require 'tasks/facebooker'
rescue LoadError
  puts "Install facebooker to access its tasks"
end