require 'rake/clean'
require 'pathname'
require 'yaml'

build_dir = Pathname('build')

publication_source_dir = Pathname('publication')
manuscript_source_dir = publication_source_dir / 'manuscript'
manuscript_listing_source_file = publication_source_dir / 'manuscript.yaml'
publication_source_file = publication_source_dir / 'publication.yaml'

ebook_source_dir = Pathname('ebook')
ebook_format_source_dir = ebook_source_dir / 'format'
ebook_template_source_dir = ebook_source_dir / 'template'

paperback_source_dir = Pathname('paperback')
paperback_format_source_dir = paperback_source_dir / 'format'
paperback_template_source_dir = paperback_source_dir / 'template'

ebook_dir = build_dir / 'ebooks'
ebook_data_dir = ebook_dir / '_data'
ebook_manuscript_dir = ebook_dir / 'manuscript'
ebook_manuscript_listing_file = ebook_data_dir / 'manuscript.yaml'
ebook_publication_file = ebook_data_dir / 'publication.yaml'

paperback_dir = build_dir / 'paperback'
paperback_format_dir = paperback_dir / 'format'
paperback_format_file = paperback_format_dir / 'dbp.tex'
paperback_manuscript_dir = paperback_dir / 'manuscript'
paperback_manuscript_listing_file = paperback_dir / 'manuscript.tex'
paperback_publication_file = paperback_dir / 'publication.tex'

directory ebook_dir
directory ebook_data_dir
directory ebook_manuscript_dir
directory paperback_dir
directory paperback_format_dir
directory paperback_manuscript_dir

manuscript_listing = YAML.load_file(manuscript_listing_source_file)

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_format_files, :ebook_template_files, ebook_publication_file, :ebook_manuscript_files, ebook_manuscript_listing_file ] do
  runcommand "cd #{ebook_dir} && rake"
end

task ebook_format_files: [ebook_dir] do
  cp_r "#{ebook_format_source_dir}/.", ebook_dir
end

task ebook_manuscript_files: [ebook_manuscript_dir] do
  runcommand "tex2md #{manuscript_source_dir} #{ebook_manuscript_dir}"
end

task ebook_manuscript_listing_file => [ebook_data_dir] do
  File.open(ebook_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "- manuscript/#{line}.html"}
  end
end

task ebook_publication_file => [ebook_data_dir] do
  cp publication_source_file, ebook_publication_file
end

task ebook_template_files: [ebook_dir] do
  cp_r "#{ebook_template_source_dir}/.", ebook_dir
end

desc 'Build the paperback interior PDF'
task paperback: [paperback_format_file, :paperback_template_files, paperback_publication_file, :paperback_manuscript_files, paperback_manuscript_listing_file] do
  runcommand "cd #{paperback_dir} && rake"
end

task paperback_format_file => [:paperback_format_files] do
  runcommand "cd #{paperback_format_dir} && rake"
end

task paperback_format_files: [paperback_format_dir] do
  cp_r "#{paperback_format_source_dir}/.", paperback_format_dir
end

task paperback_manuscript_files: [paperback_manuscript_dir] do
  cp_r "#{manuscript_source_dir}/.", paperback_manuscript_dir
end

task paperback_manuscript_listing_file => [paperback_dir] do
  File.open(paperback_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "\\input manuscript/#{line}"}
  end
end

task paperback_publication_file => [paperback_dir] do
  yaml = YAML.load_file(publication_source_file)
  File.open(paperback_publication_file, 'w') do |f|
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

task paperback_template_files: [paperback_dir] do
  cp_r "#{paperback_template_source_dir}/.", paperback_dir
end

def runcommand(command, redirect: true, background: false)
    full_command = "#{command}#{' 2>&1' if redirect}#{' &' if background}"
    puts ">>> #{full_command}"
    IO.popen(full_command).each_line{|line| puts line}
end

# CLEAN << build_out
CLOBBER << build_dir
