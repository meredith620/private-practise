#! /bin/env ruby

# $LOAD_PATH.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__)+"/lib")

require "net/ssh"
require "net/scp"
## ruby -ropenssl -e 'puts OpenSSL::OPENSSL_VERSION'
require "ostruct"
require "set"
require "server_info"
require "threadpool"

class Package
  attr_accessor :servers, :sync_folder, :remote_exec, :config_entry, :template_dir, :config_dir, :custom_args, :parallesim
  def initialize(id)
    # basic server info
    @home_path = File.dirname(__FILE__)
    @tmp_root = "/tmp"
    @id = id
    @tmp_work_folder = "#{@tmp_root}/#{@id}/"
    @servers = []
    @custom_args = []
    @gsub_mark = "{CARGS}"
    # sync && cmd
    @sync_folder = ""
    @remote_exec = ""    
    # configs
    @substitute_rb = "template.rb"
    @config_instance = ""
    @config_entry = "global_config"
    @template_dir = "template"
    @config_dir = "config"
    @parallesim = 1
    # check
    self.check_d(@tmp_work_folder)
  end

  def check_d(d)
    # check remote dir args, any '..' is illegal
    if d.index("..") != nil
      raise "path: #{d} is illegal, '..' can't appear"
    end
  end

  def set_config_instance(instance_dir)
      @config_instance = instance_dir
  end

  def check_exec(cmd)
    puts "check cmd: #{cmd}"
    if cmd.index(";rm ") != nil or cmd.index("&rm ") != nil or cmd.index(" rm ") != nil
      raise "cmd: cmd is illegal, \"rm\" can't appear"
    end
  end

  def machine_work(params)
    subdir = params.subdir
    target_dir = params.target_dir
    ip = params.ip
    port = params.port
    usr = params.usr
    pwd = params.pwd
    cargs = params.cargs
    Net::SSH.start(ip, usr, :port => port, :password => pwd, :compression_level => 9) do |ssh|
      puts "connect: host: #{ip}, port: #{port}, usr: #{usr}, pwd: #{pwd}"
      # sync files
      self.sync(@sync_folder, @tmp_work_folder, ssh)
      # config actions
      self.prepare_config(ssh)
      ssh.loop
      # exec cmds
      cmd = "cd #{target_dir}; #{@remote_exec.gsub(@gsub_mark, cargs)}"
      self.remote_exec(ssh, cmd)
      # cleanup env
      self.cleanup(ssh)
    end
  end

  def dowork(server_info)
    # check
    self.check_exec(@remote_exec)
    subdir = self.get_last_dir(@sync_folder)
    target_dir = @tmp_work_folder + "/" + subdir
    tpool = TP.new(@parallesim)
    # @servers.each do |srv|
    for i in (0..@servers.size-1)
      si = server_info.get_server(@servers[i])
      ip = si[0]
      port = si[1]
      usr = si[2]
      pwd = si[3]

      cargs = ''
      if @custom_args.size > i
        cargs = @custom_args[i]
      end
      
      # ------- for params package multi threads --------
      params = OpenStruct.new
      params.subdir = subdir
      params.target_dir = target_dir
      params.ip = ip
      params.port = port
      params.usr = usr
      params.pwd = pwd
      params.cargs = cargs      
      # self.machine_work(params)
      tpool.add_task(method(:machine_work), params)
    end
    tpool.destory
  end

  def prepare_config(ssh)
    if @sync_folder.empty?
      # puts "no local folder"
    else
      subdir = self.get_last_dir(@sync_folder)
      target_dir = @tmp_work_folder + "/" + subdir
      ssh.exec!("test -d #{target_dir}/#{config_dir} || mkdir -p #{target_dir}/#{config_dir}")
      puts "@substitute_rb =>> #{target_dir}/_#{@substitute_rb}"
      ssh.scp.upload!(@home_path + "/" + @substitute_rb, "#{target_dir}/_#{@substitute_rb}")
      # ssh.scp.upload!(@config_entry, "#{target_dir}/#{config_dir}/#{@config_entry}")
      ssh.scp.upload!(@config_instance, @tmp_work_folder + "/", :recursive => true)
      res = ssh.exec!("cd #{target_dir} && ruby _#{@substitute_rb} #{@tmp_work_folder}/#{@config_instance}/#{@config_entry} #{@template_dir} #{config_dir}")
      puts res
    end
  end

  def get_last_dir(sync_folder)
    subdir = sync_folder
    if sync_folder.rindex("/") != nil
      subdir = sync_folder[sync_folder.rindex("/"), sync_folder.size]
    end
    subdir
  end

  def remote_exec(ssh, cmd)
    ssh.exec(cmd)
    ssh.loop
  end

  def sync(local_dir, remote_dir, ssh)    
    self.check_d(@sync_folder)
    ssh.exec!("mkdir -p #{remote_dir}")
    if local_dir.empty?
      # puts "no local folder"
    else
      puts "#{local_dir} =>> #{remote_dir}"
      ssh.scp.upload!(local_dir, remote_dir, :recursive => true) do |ch, name, sent, total|
        print "\r #{File.basename(name)}: \t#{((sent.to_f+1) * 100 / (total.to_f+1)).to_i}%"
        # print "\r#{name}: \t#{((sent.to_f +1)* 100 / (total.to_f + 1)).to_i}%"
      end
    end
  end

  def cleanup(ssh)
    puts "cd #{@tmp_root} && rm -rf ./#{@id}"
    ssh.exec!("cd #{@tmp_root} && rm -rf ./#{@id}")
  end
  
  def show
    printf("servers: %s\n", @servers)
  end
end

class DeployWorker
  def initialize(server_info)
    @names = Set.new
    @packages = Array.new
    @config_instance = ""
    @server_info = server_info
  end

  def set_config_instance(config_dir)
    @config_instance = config_dir
    $:.unshift(File.dirname(@config_instance + "/."))
  end
  
  def load_deploy(filename)
    self.instance_eval(File.read(filename), filename)
  end

  def create_name(pname)
    "%s-%d-%d" % [pname, Time.now.to_i, rand(100)]
  end
  def find_name(set, pname)
    name = create_name(pname)
    while set.member?(name) == true
      name = create_name(pname)
      sleep(0.5)
    end
    name
  end
  
  def config(pname)
    ele = OpenStruct.new()
    ele.name = find_name(@names, pname)
    ele.pins = Package.new(ele.name)
    ele.pins.set_config_instance(@config_instance)
    @names.add(ele.name)
    @packages.push(ele)
    yield ele.pins
  end

  def dowork
    @packages.each { |ele|
      pname = ele.name
      pins = ele.pins
      printf("[deploying: %s]\n", pname)
      pins.dowork(@server_info)
    }
  end
  
  def show
    @packages.each { |ele|
      pname = ele.name
      pins = ele.pins
      printf("name: %s\n", pname)
      pins.show
    }
  end
end

# usage: $0 $config_instance $servers $deploy_config
def main()
  # server info
  config_instance = ARGV.shift
  servers = ARGV.shift
  server_info = ServerInfo.new
  server_info.load_server(servers)
  # deploy config
  config_file = ARGV.shift
  dw = DeployWorker.new(server_info)
  dw.set_config_instance(config_instance)
  dw.load_deploy(config_file)
  dw.dowork
  # dw.show
end

if __FILE__ == $0
  main()
end
