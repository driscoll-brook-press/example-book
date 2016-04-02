require 'rake/clean'
require 'pathname'
require 'yaml'

build_dir = 'build'
build_out = "#{build_dir}/out"

format_source_dir = 'format'
publication_source_dir = 'publication'
metadata_source_file = "#{publication_source_dir}/publication.yaml"
content_source_dir = "#{publication_source_dir}/content"
content_source_file = "#{publication_source_dir}/content.yaml"

ebook_format_source_dir = "#{format_source_dir}/ebook"
ebook_publication_source_dir = "#{publication_source_dir}/ebook"

paperback_format_source_dir = "#{format_source_dir}/paperback"
paperback_publication_source_dir = "#{publication_source_dir}/paperback"

ebook_build_dir = "#{build_dir}/ebooks"
ebook_content_build_dir = "#{ebook_build_dir}/content"
ebook_format_build_dir = ebook_build_dir

paperback_build_dir = "#{build_dir}/paperback"
paperback_content_build_dir = "#{paperback_build_dir}/content"
paperback_content_build_file = "#{paperback_build_dir}/content.tex"
paperback_format_build_dir = "#{paperback_build_dir}/format"
paperback_metadata_build_file = "#{paperback_build_dir}/publication.tex"

directory build_out
directory ebook_build_dir
directory ebook_format_build_dir
directory ebook_content_build_dir
directory paperback_build_dir
directory paperback_format_build_dir
directory paperback_content_build_dir

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_format, :ebook_publication, :ebook_content, build_out] do
  `cd #{ebook_build_dir} && rake`
end

desc 'Build the paperback interior PDF'
task paperback: [:paperback_format, :paperback_publication, :paperback_content, build_out] do
  `cd #{paperback_build_dir} && rake`
end

task ebook_format: [ebook_format_build_dir] do
  cp_r "#{ebook_format_source_dir}/.", ebook_format_build_dir
end

task ebook_content: [ebook_content_build_dir] do
  `tex2md #{content_source_dir} #{ebook_content_build_dir}`
end

task ebook_publication: [ebook_build_dir] do
  cp_r "#{ebook_publication_source_dir}/.", ebook_build_dir
end

task paperback_format: [paperback_format_build_dir] do
  cp_r "#{paperback_format_source_dir}/.", paperback_format_build_dir
  `cd #{paperback_format_build_dir} && rake`
end

task paperback_content: [paperback_content_build_dir] do
  cp_r "#{content_source_dir}/.", paperback_content_build_dir
  paperback_content(content_source_file, paperback_content_build_file)
end

task paperback_publication: [paperback_build_dir] do
  cp_r "#{paperback_publication_source_dir}/.", paperback_build_dir
  paperback_metadata(metadata_source_file, paperback_metadata_build_file)
end

def paperback_content(yaml_file, tex_file)
  yaml = YAML.load_file(yaml_file)
  File.open(tex_file, 'w') do |f|
    yaml.each{|line| f.puts "\\input content/#{line}"}
  end
end

def paperback_metadata(yaml_file, tex_file)
  yaml = YAML.load_file(yaml_file)
  File.open(tex_file, 'w') do |f|
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

CLEAN << build_out
CLOBBER << build_dir
