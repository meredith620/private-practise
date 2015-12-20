#! /bin/env ruby
# yes, I know there is no real thread in c interpreter

require "thread"
require "ostruct"

class TaskQueue<Queue
  def initialize
    super
    @shutdown = false
  end
  
  def set_shutdown
    @shutdown = true
  end

  def shutdown?
    @shutdown
  end  
end

def worker(task_queue, id)
  while true
    if (task_queue.empty? && task_queue.shutdown?)
      break
    end
    puts "id: %s, task queue size: %d" % [id, task_queue.size]
    begin
      work_element = task_queue.pop(true)
      # send(work_element.func, work_element.args)
      work_element.func.call(work_element.args)
      # work_element.func.call(work_element.args)
    rescue
      # puts "An error occurred: #{$!}"
      sleep(1)
    end
  end
end

class TP
  def initialize(size)
    @task_queue = TaskQueue.new
    @worker_ids = Array.new(size)
    i = 0
    @worker_ids.map! { |e| Thread.new { worker(@task_queue, i=i+1) } }
  end

  def add_task(func, args)
    work_element = OpenStruct.new
    work_element.func = func
    work_element.args = args
    puts "add %s, %s" % [func,args]
    @task_queue.push(work_element)
  end

  def destory
    puts "in destory"
    @task_queue.set_shutdown
    @worker_ids.each { |thr| thr.join }
  end
end

def main
  tpool = TP.new(3)

  (1..15).each { |i|
    tpool.add_task(method(:puts), "string %d" % i)
  }

  tpool.destory
  puts "after destory"
end



def test_tp
  def test_worker(ostruct)
    print("ostruct=> one: %s, two: %s\n" % [ostruct.one, ostruct.two])
  end
  tpool = TP.new(3)
  (1..15).each { |i|
    e = OpenStruct.new
    e.one = "%d-one" % i
    e.two = "%d-two" % i
    # tpool.add_task(Proc.new {|a| test_worker(a)}, e)
    tpool.add_task(method(:test_worker),e)
  }

  tpool.destory
end

# def test_queue
#   queue = Queue.new
#   producer = Thread.new do
#     5.times do |i|
#       sleep rand(i) # simulate expense
#       queue << i
#       puts "#{i} produced"
#     end
#   end
#   consumer = Thread.new do
#     5.times do |i|
#       value = queue.pop
#       sleep rand(i/2) # simulate expense
#       puts "consumed #{value}"
#     end
#   end
#   consumer.join

#   # test proc
#   we = OpenStruct.new
#   we.func = proc {puts "ahahha"}
#   we.func.call
# end

if __FILE__ == $0
  # test_queue
  test_tp
  main
end
