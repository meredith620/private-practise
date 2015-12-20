#! /bin/env ruby

# $LOAD_PATH.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__)+"/lib")
require "net/ssh"
require "net/scp"
## ruby -ropenssl -e 'puts OpenSSL::OPENSSL_VERSION'

Net::SSH.start("d52", "lvliang") do |ssh|
  res = ssh.exec("cd /tmp")
  puts res
  res = ssh.exec("pwd")
  puts res
end

Net::SCP.start("d52", "lvliang") do |scp|
  scp.upload!("net", "/tmp/haha", :recursive => true) do |ch, name, sent, total|
    print "\r#{name}: \t#{(sent.to_f * 100 / total.to_f).to_i}%"
  end
end

# require "rubygems"
# require "net/zookeeper"
