#! /bin/env ruby

$:.unshift(File.dirname(__FILE__))

require "threadpool"

def test_thread()  
  tpool = TP.new(15)

  (1..100).each { |i|
    tpool.add_task(:puts, "string %d" % i)
  }

  tpool.destory()
  puts "after destory"
end


if __FILE__ == $0
  test_thread()
end
