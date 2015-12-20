#! /bin/env ruby

def substitute(global_config_file, template_file, config_file)
  load global_config_file
  File.open(template_file, "r") do |rf|
    File.open(config_file, "w") do  |wf|
      while line = rf.gets
        line.gsub! '"', '\"'
        line.gsub! '\\', '\\\\\\\\'
        evaluated_str = eval('"' + line + '"')
        # puts evaluated_str
        wf.puts(evaluated_str)
      end
    end
  end
end

def batch_substitute(global_config_file, template_dir, config_dir)
  # puts Dir.entries(template_dir)
  if File.exist?(template_dir) == false
    return
  end
  if File.exist?(config_dir) == false
    Dir::mkdir(config_dir)
  end
  Dir.entries(template_dir).each do |name|
    if name == "." or name == ".."
      next
    end
    substitute(global_config_file, "#{template_dir}/#{name}", "#{config_dir}/#{name}")
  end
end

def main()
  # substitute.rb global_config template_file config_file
  global_config_file = ARGV.shift
  # template_file = ARGV.shift
  # config_file = ARGV.shift
  # substitute(global_config_file, template_file, config_file)
  template_dir = ARGV.shift
  config_dir = ARGV.shift
  if File.file?(template_dir)
    template_file = template_dir
    config_file = config_dir
    substitute(global_config_file, template_file, config_file)
  else
    batch_substitute(global_config_file, template_dir, config_dir)
  end
end

if __FILE__ == $0
  main
end
