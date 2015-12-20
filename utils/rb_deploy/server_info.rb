#! /bin/env ruby

class ServerInfo
  attr_accessor :servers
  def initialize
    @servers = Hash.new
  end

  def config
    yield self
  end

  def load(host, ip, port, usr, pwd)
    @servers[host] = [ip, port, usr, pwd]
  end

  def load_server(filename)
    self.instance_eval(File.read(filename), filename)
  end

  def get_server(host)
    return @servers[host]
  end

  def show
    puts @servers
  end

  def test
    puts @servers["servers1"][0]
  end
end

def main
  server = ARGV.shift
  si = ServerInfo.new
  si.load_server(server)
  si.show
  si.test
end

if __FILE__ == $0
  main
end
