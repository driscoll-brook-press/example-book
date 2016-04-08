require 'rake/clean'
require 'pathname'
require 'yaml'
require 'rake/ext/pathname'

PUBLICATION_SOURCE_DIR = Pathname('publication').expand_path
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

BUILDER = Pathname('builder')

cover_source_dir = Pathname('covers')
paperback_source_dir = Pathname('paperback/template')

manuscript_source_dir = PUBLICATION_SOURCE_DIR / 'manuscript'
manuscript_listing_source_file = PUBLICATION_SOURCE_DIR / 'manuscript.yaml'

PDF_FORMAT_BUILDER = BUILDER / 'pdf-format'
PDF_FORMAT_BUILD_DIR = BUILD_DIR / 'pdf-format'
PDF_FORMAT_FILE = PDF_FORMAT_BUILD_DIR / 'dbp.fmt'
directory PDF_FORMAT_BUILD_DIR

EPUB_BUILDER = BUILDER / 'epub'
EPUB_BUILD_DIR = BUILD_DIR / 'epub'
directory EPUB_BUILD_DIR

paperback_dir = BUILD_DIR / 'paperback'
paperback_manuscript_dir = paperback_dir / 'manuscript'
paperback_manuscript_listing_file = paperback_dir / 'manuscript.tex'
paperback_publication_file = paperback_dir / 'publication.tex'

directory paperback_dir

manuscript_listing = YAML.load_file(manuscript_listing_source_file)
EBOOK_COVER_IMAGE_FILE = Pathname("covers/#{SLUG}-cover-ebook.jpg").expand_path

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

task :none

task default: :all

desc 'Build all formats (pdf, epub, mobi)'
task all: [:pdf, :mobi]

desc 'Build the epub file'
task epub: EPUB_FILE

desc 'Build the mobi file'
task mobi: MOBI_FILE

desc 'Build the PDF file'
task pdf: PDF_FILE

EPUB_BUILD_FILES = copy_files(from: EPUB_BUILDER, to: EPUB_BUILD_DIR)

file EPUB_FILE => EPUB_BUILD_FILES do |t|
  cd(EPUB_BUILD_DIR) { sh 'rake', "DBP_OUT_DIR=#{OUT_DIR}", "DBP_PUBLICATION_DIR=#{PUBLICATION_SOURCE_DIR}", "DBP_COVER_IMAGE_FILE=#{EBOOK_COVER_IMAGE_FILE}" }
end

file MOBI_FILE => [EPUB_FILE] do
  sh 'kindlegen', EPUB_FILE.to_s
end

file PDF_FILE do |t|
  cd(paperback_dir) { sh 'rake', "DBP_PDF_FILE=#{t.name}", "DBP_PDF_FORMAT_FILE=#{PDF_FORMAT_FILE}" }
end
file PDF_FILE => [PDF_FORMAT_FILE]
file PDF_FILE => copy_files(from: paperback_source_dir, to: paperback_dir)
file PDF_FILE => copy_files(from: manuscript_source_dir, to: paperback_manuscript_dir)
file PDF_FILE => [paperback_publication_file, paperback_manuscript_listing_file]

file PDF_FORMAT_FILE do
  cd(PDF_FORMAT_BUILD_DIR) { sh 'rake' }
end
file PDF_FORMAT_FILE => copy_files(from: PDF_FORMAT_BUILDER, to: PDF_FORMAT_BUILD_DIR)

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
