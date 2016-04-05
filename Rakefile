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
mobi_file = build_dir / 'kindle.epub'
epub_file = build_dir / 'standard.epub'

paperback_dir = build_dir / 'paperback'
paperback_format_dir = paperback_dir / 'format'
paperback_format_file = paperback_format_dir / 'dbp.fmt'
paperback_manuscript_dir = paperback_dir / 'manuscript'
paperback_manuscript_listing_file = paperback_dir / 'manuscript.tex'
paperback_publication_file = paperback_dir / 'publication.tex'
pdf_file = build_dir / 'book.pdf'

directory ebook_dir
directory ebook_data_dir
directory ebook_cover_dir
file mobi_file
file epub_file

directory paperback_dir
file pdf_file

publication = YAML.load_file(publication_source_file)
manuscript_listing = YAML.load_file(manuscript_listing_source_file)
cover_source_file = cover_source_dir / "#{publication['slug']}-cover-ebook.jpg"

def files_in(dir)
  FileList.new(dir / '**/*') do |l|
    l.exclude { |f| File.directory? f }
  end
end

def copy_files(from:, to:)
  sources = files_in(from)
  targets = sources.pathmap("%{^#{from}/,#{to}/}p")
  sources.zip(targets).each do |source, target|
    target_dir = target.pathmap('%d')
    directory target_dir
    file target => [target_dir, source] do |t|
      cp source, target_dir
    end
  end
  targets
end

def translate_tex_to_markdown(from:, to:)
  sources = files_in(from)
  targets = sources.pathmap("%{^#{from}/,#{to}/}X.md")
  sources.zip(targets).each do |source, target|
    target_dir = target.pathmap('%d')
    directory target_dir
    file target => [target_dir, source] do |t|
      sh 'tex2md', source, target_dir
    end
  end
  targets
end

task :none

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:epub, :mobi]

desc 'Build the epub file (with cover)'
task epub: epub_file

desc 'Build the mobi file (sans cover)'
task mobi: mobi_file

desc 'Build the paperback PDF file'
task paperback: pdf_file

file epub_file do
  cd(ebook_dir) { sh 'rake', 'check_standard' }
end

file mobi_file do
  cd(ebook_dir) { sh 'rake', 'check_kindle' }
end

EBOOK_BUILD_FILES = copy_files(from: ebook_template_source_dir, to: ebook_dir)
                      .include(copy_files(from: ebook_format_source_dir, to: ebook_dir))
                      .include(translate_tex_to_markdown(from: manuscript_source_dir, to: ebook_manuscript_dir))
                      .include(ebook_cover_file, ebook_publication_file, ebook_manuscript_listing_file)

%w[epub_file mobi_file].each do |target|
  file epub_file => EBOOK_BUILD_FILES
end

file ebook_manuscript_listing_file => [manuscript_listing_source_file, ebook_data_dir] do
  File.open(ebook_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "- manuscript/#{line}.html"}
  end
end

file ebook_publication_file => [publication_source_file, ebook_data_dir] do
  cp publication_source_file, ebook_publication_file
end

file ebook_cover_file => [cover_source_file, ebook_cover_dir] do
  cp cover_source_file, ebook_cover_file
end

file pdf_file do
  cd(paperback_dir) { sh 'rake' }
end
file pdf_file => copy_files(from: paperback_template_source_dir, to: paperback_dir)
file pdf_file => copy_files(from: manuscript_source_dir, to: paperback_manuscript_dir)
file pdf_file => [paperback_format_file, paperback_publication_file, paperback_manuscript_listing_file]

file paperback_format_file do |_|
  cd(paperback_format_dir) { sh 'rake' }
end
file paperback_format_file => copy_files(from: paperback_format_source_dir, to: paperback_format_dir)

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

# CLEAN << build_out
CLOBBER << build_dir
