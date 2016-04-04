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
paperback_format_file = paperback_format_dir / 'dbp.fmt'
paperback_manuscript_dir = paperback_dir / 'manuscript'
paperback_manuscript_listing_file = paperback_dir / 'manuscript.tex'
paperback_publication_file = paperback_dir / 'publication.tex'

directory ebook_dir

publication = YAML.load_file(publication_source_file)
manuscript_listing = YAML.load_file(manuscript_listing_source_file)
cover_source_file = cover_source_dir / "#{publication['slug']}-cover-ebook.jpg"

def copy_files_task(task_symbol, source_dir, excludes, dest_dir)
  FileList.new(source_dir / '**/*') do |l|
    l.exclude { |f| excludes.include? f.pathmap('%f') }
    l.exclude { |f| File.directory? f }
  end.each do |source_file|
    target_file = source_file.pathmap("%{^#{source_dir}/,#{dest_dir}/}p")
    target_dir = target_file.pathmap('%d')
    directory target_dir
    file target_file => [source_file, target_dir] do |t|
      cp source_file, t.name
    end
    task task_symbol => target_file
  end
end

copy_files_task(:ebook_format_files, ebook_format_source_dir, %w[README.md], ebook_dir)
copy_files_task(:ebook_template_files, ebook_template_source_dir, %w[README.md], ebook_dir)
copy_files_task(:paperback_format_files, paperback_format_source_dir, %w[README.md], paperback_format_dir)
copy_files_task(:paperback_manuscript_files, manuscript_source_dir, %w[], paperback_manuscript_dir)
copy_files_task(:paperback_template_files, paperback_template_source_dir, %[README.md], paperback_dir)

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_format_files, :ebook_template_files, ebook_cover_file, ebook_publication_file, :ebook_manuscript_files, ebook_manuscript_listing_file ] do
  runcommand "cd #{ebook_dir} && rake"
end

directory ebook_manuscript_dir
task ebook_manuscript_files: [ebook_manuscript_dir] do
  runcommand "tex2md #{manuscript_source_dir} #{ebook_manuscript_dir}"
end

directory ebook_data_dir
file ebook_manuscript_listing_file => [manuscript_listing_source_file, ebook_data_dir] do
  File.open(ebook_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "- manuscript/#{line}.html"}
  end
end

file ebook_publication_file => [publication_source_file, ebook_data_dir] do
  cp publication_source_file, ebook_publication_file
end

directory ebook_cover_dir
file ebook_cover_file => [cover_source_file, ebook_cover_dir] do
  cp cover_source_file, ebook_cover_file
end

desc 'Build the paperback interior PDF'
task paperback: [paperback_format_file, :paperback_template_files, paperback_publication_file, :paperback_manuscript_files, paperback_manuscript_listing_file] do
  runcommand "cd #{paperback_dir} && rake"
end

task paperback_format_file => [:paperback_format_files] do
  runcommand "cd #{paperback_format_dir} && rake"
end

directory paperback_dir
file paperback_manuscript_listing_file => [manuscript_listing_source_file, paperback_dir] do
  File.open(paperback_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "\\input manuscript/#{line}"}
  end
end

file paperback_publication_file => [publication_source_file, paperback_dir] do
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

def runcommand(command, redirect: true, background: false)
    full_command = "#{command}#{' 2>&1' if redirect}#{' &' if background}"
    puts ">>> #{full_command}"
    IO.popen(full_command).each_line{|line| puts line}
end

# CLEAN << build_out
CLOBBER << build_dir
