require 'rake/clean'
require 'pathname'
require 'yaml'

build_dir = 'build'

format_source_dir = 'format'
publication_source_dir = 'publication'
metadata_source_file = "#{publication_source_dir}/metadata.yaml"
content_source_dir = "#{publication_source_dir}/content"
content_listing_source_file = "#{publication_source_dir}/content.yaml"

ebook_format_source_dir = "#{format_source_dir}/ebook"
ebook_publication_source_dir = "#{publication_source_dir}/ebook"

paperback_format_source_dir = "#{format_source_dir}/paperback"
paperback_publication_source_dir = "#{publication_source_dir}/paperback"

ebook_dir = "#{build_dir}/ebooks"
ebook_content_dir = "#{ebook_dir}/content"

paperback_dir = "#{build_dir}/paperback"
paperback_content_dir = "#{paperback_dir}/content"
paperback_content_listing_file = "#{paperback_dir}/content.tex"
paperback_format_dir = "#{paperback_dir}/format"
paperback_metadata_file = "#{paperback_dir}/metadata.tex"

directory ebook_dir
directory ebook_content_dir
directory paperback_dir
directory paperback_content_dir
directory paperback_format_dir

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_content_files, :ebook_format_files, :ebook_publication_files] do
  runcommand "cd #{ebook_dir} && rake"
end

task ebook_content_files: [ebook_content_dir] do
  runcommand "tex2md #{content_source_dir} #{ebook_content_dir}"
end

task ebook_format_files: [ebook_dir] do
  cp_r "#{ebook_format_source_dir}/.", ebook_dir
end

task ebook_publication_files: [ebook_dir] do
  cp_r "#{ebook_publication_source_dir}/.", ebook_dir
end

desc 'Build the paperback interior PDF'
task paperback: [:paperback_content_files, :paperback_format, :paperback_publication_files] do
  runcommand "cd #{paperback_dir} && rake"
end

task paperback_content_files: [paperback_content_listing_file, paperback_content_dir] do
  cp_r "#{content_source_dir}/.", paperback_content_dir
end

task paperback_content_listing_file => [paperback_content_dir] do
  yaml = YAML.load_file(content_listing_source_file)
  File.open(paperback_content_listing_file, 'w') do |f|
    yaml.each{|line| f.puts "\\input content/#{line}"}
  end
end

task paperback_format: [:paperback_format_files] do
  runcommand "cd #{paperback_format_dir} && rake"
end

task paperback_format_files: [paperback_format_dir] do
  cp_r "#{paperback_format_source_dir}/.", paperback_format_dir
end

task paperback_metadata_file => [paperback_dir] do
  yaml = YAML.load_file(metadata_source_file)
  File.open(paperback_metadata_file, 'w') do |f|
    f.puts "\\title={#{yaml['title']}}"
    f.puts "\\author={#{yaml['author']['name']}}"
    f.puts '\\isbns={'
    f.puts yaml['isbn'].map{|k,v| "ISBN: #{v} (#{k})"}.join('\\break ')
    f.puts '}'
    f.puts '\\rights={'
    f.puts yaml['rights'].map{|r| "#{r['material']} \\copyright~#{r['date']} #{r['owner']}"}.join('\\break ')
    f.puts '}'
  end
end

task paperback_publication_files: [paperback_metadata_file, paperback_dir] do
  cp_r "#{paperback_publication_source_dir}/.", paperback_dir
end

def runcommand(command, redirect: true, background: false)
    full_command = "#{command}#{' 2>&1' if redirect}#{' &' if background}"
    puts ">>> #{full_command}"
    IO.popen(full_command).each_line{|line| puts line}
end

# CLEAN << build_out
CLOBBER << build_dir
