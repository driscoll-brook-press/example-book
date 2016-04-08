require 'rake/clean'
require 'pathname'
require 'yaml'
require 'rake/ext/pathname'

PUBLICATION_SOURCE_DIR = Pathname('publication')
PUBLICATION_SOURCE_FILE = PUBLICATION_SOURCE_DIR / 'publication.yaml'
PUBLICATION = YAML.load_file(PUBLICATION_SOURCE_FILE)
SLUG = PUBLICATION['slug']

OUT_DIR = Pathname('uploads').expand_path
EPUB_FILE = (OUT_DIR / SLUG).ext('epub')
MOBI_FILE = EPUB_FILE.ext('mobi')
PDF_FILE = EPUB_FILE.ext('pdf')
file EPUB_FILE
file MOBI_FILE
file PDF_FILE

DBP_TMP_DIR = Pathname('/var/tmp/dbp')
BUILD_DIR = DBP_TMP_DIR + SLUG

cover_source_dir = Pathname('covers')
ebook_source_dir = Pathname('ebook')
paperback_source_dir = Pathname('paperback')

manuscript_source_dir = PUBLICATION_SOURCE_DIR / 'manuscript'
manuscript_listing_source_file = PUBLICATION_SOURCE_DIR / 'manuscript.yaml'

ebook_format_source_dir = ebook_source_dir / 'format'
ebook_template_source_dir = ebook_source_dir / 'template'

paperback_format_source_dir = paperback_source_dir / 'format'
paperback_template_source_dir = paperback_source_dir / 'template'

ebook_dir = BUILD_DIR / 'ebooks'
ebook_cover_dir = ebook_dir / 'cover'
ebook_data_dir = ebook_dir / '_data'
ebook_manuscript_dir = ebook_dir / 'manuscript'
ebook_cover_file = ebook_cover_dir / 'cover.jpg'
ebook_manuscript_listing_file = ebook_data_dir / 'manuscript.yaml'
ebook_publication_file = ebook_data_dir / 'publication.yaml'

paperback_dir = BUILD_DIR / 'paperback'
paperback_format_dir = paperback_dir / 'format'
paperback_format_file = paperback_format_dir / 'dbp.fmt'
paperback_manuscript_dir = paperback_dir / 'manuscript'
paperback_manuscript_listing_file = paperback_dir / 'manuscript.tex'
paperback_publication_file = paperback_dir / 'publication.tex'

directory ebook_dir
directory ebook_data_dir
directory ebook_cover_dir

directory paperback_dir

manuscript_listing = YAML.load_file(manuscript_listing_source_file)
cover_source_file = cover_source_dir / "#{SLUG}-cover-ebook.jpg"

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

desc 'Build the epub file'
task epub: EPUB_FILE

desc 'Build the mobi file'
task mobi: MOBI_FILE

desc 'Build the paperback PDF file'
task paperback: PDF_FILE

EBOOK_BUILD_FILES = copy_files(from: ebook_format_source_dir, to: ebook_dir)
                      .include(copy_files(from: ebook_template_source_dir, to: ebook_dir))
                      .include(translate_tex_to_markdown(from: manuscript_source_dir, to: ebook_manuscript_dir))
                      .include(ebook_cover_file, ebook_publication_file, ebook_manuscript_listing_file)

file EPUB_FILE => EBOOK_BUILD_FILES do |t|
  cd(ebook_dir) { sh 'rake', "DBP_OUT_DIR=#{OUT_DIR}", 'check'}
end

file MOBI_FILE => EPUB_FILE do |t|
  cd(ebook_dir) { sh 'rake', "DBP_OUT_DIR=#{OUT_DIR}", 'mobi' }
end

file ebook_manuscript_listing_file => [manuscript_listing_source_file, ebook_data_dir] do
  File.open(ebook_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "- manuscript/#{line}.html"}
  end
end

file ebook_publication_file => [PUBLICATION_SOURCE_FILE, ebook_data_dir] do |t|
  cp PUBLICATION_SOURCE_FILE, t.name
end

file ebook_cover_file => [cover_source_file, ebook_cover_dir] do |t|
  cp cover_source_file, t.name
end

file PDF_FILE do |t|
  cd(paperback_dir) { sh 'rake', "DBP_PDF_FILE=#{t.name}" }
end
file PDF_FILE => [paperback_format_file]
file PDF_FILE => copy_files(from: paperback_template_source_dir, to: paperback_dir)
file PDF_FILE => copy_files(from: manuscript_source_dir, to: paperback_manuscript_dir)
file PDF_FILE => [paperback_publication_file, paperback_manuscript_listing_file]

file paperback_format_file do |_|
  cd(paperback_format_dir) { sh 'rake' }
end
file paperback_format_file => copy_files(from: paperback_format_source_dir, to: paperback_format_dir)

file paperback_manuscript_listing_file => [manuscript_listing_source_file, paperback_dir] do
  File.open(paperback_manuscript_listing_file, 'w') do |f|
    manuscript_listing.each{|line| f.puts "\\input manuscript/#{line}"}
  end
end

file paperback_publication_file => [PUBLICATION_SOURCE_FILE, paperback_dir] do |t|
  File.open(t.name, 'w') do |f|
    f.puts "\\title={#{PUBLICATION['title']}}"
    f.puts "\\author={#{PUBLICATION['author']['name']}}"
    f.puts '\\isbns={'
    f.puts PUBLICATION['isbn'].map{|k,v| "ISBN: #{v} (#{k})"}.join('\\break ')
    f.puts '}'
    f.puts '\\rights={'
    f.puts PUBLICATION['rights'].map{|r| "#{r['material']} \\copyright~#{r['date']} #{r['owner']}"}.join('\\break ')
    f.puts '}'
  end
end

CLEAN.include BUILD_DIR
CLOBBER.include OUT_DIR
