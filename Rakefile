require 'rake/clean'
require 'pathname'
require 'yaml'
require 'rake/ext/pathname'

PUBLICATION_DIR = Pathname('publication').expand_path
PUBLICATION_FILES = FileList[PUBLICATION_DIR / '**/*']
PUBLICATION_DATA_FILE = PUBLICATION_DIR / 'publication.yaml'
PUBLICATION = YAML.load_file(PUBLICATION_DATA_FILE)
SLUG = PUBLICATION['slug']

TEMPLATE_DIR = Pathname('builder')

DBP_BUILD_DIR = Pathname('/var/tmp/dbp')
BOOK_BUILD_DIR = DBP_BUILD_DIR + SLUG

OUT_DIR = Pathname('uploads').expand_path

def copies(from:, to:)
  sources = FileList[from / '**/*'].exclude { |f| Pathname(f).directory? }
  targets = sources.pathmap("%{^#{from}/,#{to}/}p")
  targets.zip(sources).each do |target, source|
    target_dir = target.pathmap('%d')
    directory target_dir
    file target => [source, target_dir] do |t|
      cp t.source, target_dir
    end
  end
  targets
end

EPUB_TEMPLATE_DIR = TEMPLATE_DIR / 'epub'
EPUB_BUILD_DIR = BOOK_BUILD_DIR / EPUB_TEMPLATE_DIR.basename
EPUB_TEMPLATE_FILES = copies(from: EPUB_TEMPLATE_DIR, to: EPUB_BUILD_DIR)
EPUB_COVER_IMAGE_FILE = Pathname("covers/#{SLUG}-cover-ebook.jpg").expand_path
EPUB_FILE = (OUT_DIR / SLUG).ext('epub')

directory EPUB_BUILD_DIR
file EPUB_FILE => EPUB_TEMPLATE_FILES + PUBLICATION_FILES + [EPUB_BUILD_DIR, EPUB_COVER_IMAGE_FILE] do |t|
  cd(EPUB_BUILD_DIR) { sh 'rake', "DBP_PUBLICATION_DIR=#{PUBLICATION_DIR}", "DBP_COVER_IMAGE_FILE=#{EPUB_COVER_IMAGE_FILE}", "DBP_EPUB_FILE=#{t.name}" }
end

MOBI_FILE = EPUB_FILE.ext('mobi')
file MOBI_FILE => [EPUB_FILE] do |t|
  sh 'kindlegen', t.source
end

PDF_FORMAT_TEMPLATE_DIR = TEMPLATE_DIR / 'pdf-format'
PDF_FORMAT_BUILD_DIR = BOOK_BUILD_DIR / PDF_FORMAT_TEMPLATE_DIR.basename
PDF_FORMAT_TEMPLATE_FILES = copies(from: PDF_FORMAT_TEMPLATE_DIR, to: PDF_FORMAT_BUILD_DIR)
PDF_FORMAT_FILE = (BOOK_BUILD_DIR / 'dbp.fmt').expand_path

directory PDF_FORMAT_BUILD_DIR
file PDF_FORMAT_FILE => PDF_FORMAT_TEMPLATE_FILES + [PDF_FORMAT_BUILD_DIR] do |t|
  cd(PDF_FORMAT_BUILD_DIR) { sh 'rake', "DBP_PDF_FORMAT_FILE=#{t.name}" }
end

PDF_TEMPLATE_DIR = TEMPLATE_DIR / 'pdf'
PDF_BUILD_DIR = BOOK_BUILD_DIR / PDF_TEMPLATE_DIR.basename
PDF_FILE = EPUB_FILE.ext('pdf')

PDF_TEMPLATE_FILES = copies(from: PDF_TEMPLATE_DIR, to: PDF_BUILD_DIR)
directory PDF_BUILD_DIR
file PDF_FILE => PDF_TEMPLATE_FILES + PUBLICATION_FILES + [PDF_FORMAT_FILE, PDF_BUILD_DIR] do |t|
  cd(PDF_BUILD_DIR) { sh 'rake', "DBP_PUBLICATION_DIR=#{PUBLICATION_DIR}", "DBP_PDF_FORMAT_FILE=#{PDF_FORMAT_FILE}", "DBP_PDF_FILE=#{t.name}" }
end

task default: :all

desc 'Build all formats (pdf, epub, mobi)'
task all: [:pdf, :mobi]

desc 'Build the epub file'
task epub: EPUB_FILE

desc 'Build the mobi file'
task mobi: MOBI_FILE

desc 'Build the PDF file'
task pdf: PDF_FILE

CLEAN.include BOOK_BUILD_DIR
CLOBBER.include OUT_DIR
