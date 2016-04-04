require 'rake/clean'
require 'pathname'
require 'yaml'

cover_source_dir = Pathname('covers')
ebook_source_dir = Pathname('ebook')
paperback_source_dir = Pathname('paperback')
build_dir = Pathname('build')

publication_source_dir = Pathname('publication')
manuscript_source_dir = publication_source_dir / 'manuscript'
manuscript_listing_source_file = publication_source_dir / 'manuscript.yaml'
publication_source_file = publication_source_dir / 'publication.yaml'

ebook_format_source_dir = ebook_source_dir / 'format'
ebook_template_source_dir = ebook_source_dir / 'template'

paperback_format_source_dir = paperback_source_dir / 'format'
paperback_template_source_dir = paperback_source_dir / 'template'

ebook_dir = build_dir / 'ebooks'
ebook_cover_dir = ebook_dir / 'cover'
ebook_data_dir = ebook_dir / '_data'
ebook_manuscript_dir = ebook_dir / 'manuscript'
ebook_cover_file = ebook_cover_dir / 'cover.jpg'
ebook_manuscript_listing_file = ebook_data_dir / 'manuscript.yaml'
ebook_publication_file = ebook_data_dir / 'publication.yaml'

paperback_dir = build_dir / 'paperback'
paperback_format_dir = paperback_dir / 'format'
paperback_format_file = paperback_format_dir / 'dbp.tex'
paperback_manuscript_dir = paperback_dir / 'manuscript'
paperback_manuscript_listing_file = paperback_dir / 'manuscript.tex'
paperback_publication_file = paperback_dir / 'publication.tex'

directory ebook_dir
directory ebook_cover_dir
directory ebook_data_dir
directory ebook_manuscript_dir
directory paperback_dir
directory paperback_format_dir
directory paperback_manuscript_dir

publication = YAML.load_file(publication_source_file)
manuscript_listing = YAML.load_file(manuscript_listing_source_file)
cover_source_file = cover_source_dir / "#{publication['slug']}-cover-ebook.jpg"

ebook_format_source_files = FileList.new(ebook_format_source_dir / '**/*') do |l|
  l.exclude { |f| %w[README.md].include? f.pathmap('%f') }
  l.exclude { |f| File.directory? f }
end

def copy_files_task(source_files, source_dir, dest_dir, task_symbol)
  source_files.each do |source_file|
    target_file = source_file.pathmap("%{^#{source_dir}/,#{dest_dir}/}p")
    target_dir = target_file.pathmap('%d')
    directory target_dir
    file target_file => [source_file, target_dir] do |t|
      cp source_file, t.name
    end
    task task_symbol => target
  end
end

ebook_format_source_files.each do |source|
  target = source.pathmap("%{^#{ebook_format_source_dir}/,#{ebook_dir}/}p")
  target_dir = target.pathmap('%d')
  directory target_dir
  file target => [source, target_dir] do |t|
    cp source, t.name
  end
  task ebook_format_files: target
end

ebook_template_source_files = FileList.new(ebook_template_source_dir / '**/*') do |l|
  l.exclude { |f| %w[README.md].include? f.pathmap('%f') }
  l.exclude { |f| File.directory? f }
end

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_format_files, :ebook_template_files, ebook_cover_file, ebook_publication_file, :ebook_manuscript_files, ebook_manuscript_listing_file ] do
  runcommand "cd #{ebook_dir} && rake"
end

task ebook_cover_file => [ebook_cover_dir] do
  cp cover_source_file, ebook_cover_file
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
  File.open(paperback_publication_file, 'w') do |f|
    f.puts "\\title={#{publication['title']}}"
    f.puts "\\author={#{publication['author']['name']}}"
    f.puts '\\isbns={'
    f.puts publication['isbn'].map{|k,v| "ISBN: #{v} (#{k})"}.join('\\break ')
    f.puts '}'
    f.puts '\\rights={'
    f.puts publication['rights'].map{|r| "#{r['material']} \\copyright~#{r['date']} #{r['owner']}"}.join('\\break ')
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
