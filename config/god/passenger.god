##
# god configuration file for unreliable phusion passenger
#
# run with:  god -c /path/to/god.conf

# Production server
RAILS_ROOT = File.join(File.dirname(__FILE__), "../..")

God.watch do |w|
  w.name = "apache"
  w.interval = 10.seconds
  w.start = "/etc/init.d/apache2 start"
  w.restart = "/etc/init.d/apache2 restart"
  w.stop = "/etc/init.d/apache2 stop"
  w.start_grace = 20.seconds
  w.restart_grace = 90.seconds
  w.pid_file = "/var/run/apache2.pid"

  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # retart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 500.megabytes
      c.times = [3, 5]
    end
  end

  w.transition(:up, :restart) do |on|
    on.condition(:http_response_code) do |c|
      c.host = '127.0.0.1'
      c.headers = {'Host' => "votereports.org"}
      c.port = 80
      c.path = "/"
      c.code_is_not = 200
      c.timeout = 90.seconds
      c.interval = 10.seconds
    end
  end
end

