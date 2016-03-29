require 'rake/clean'
require 'pathname'

format_name = 'dbp'
format_install_dir = Pathname.new(ENV['DBP_FORMAT'] || 'DBP_FORMAT_UNDEFINED')

tex_file = "#{format_name}.tex"
format_file = "#{format_name}.fmt"
log_file = "#{format_name}.log"

task default: [:clobber, :build, :log, :install]

directory format_install_dir do |t|
  mkdir_p format_install_dir
end

file format_file => [:build]

desc 'Build the format file'
task :build do
 `pdftex -interaction=batchmode -etex -enc -ini #{tex_file}`
end

desc 'Install the format file'
task install: [format_file, format_install_dir] do
  cp format_file, format_install_dir
end

desc 'Show the log file'
task :log do
  print `cat #{log_file}`
end

CLEAN << format_file
CLEAN << log_file
CLOBBER << format_install_dir
