require 'rake/clean'
require 'pathname'

build_dir = 'build'
build_out = "#{build_dir}/out"

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_format, :ebook_publication, :ebook_manuscript]

desc 'Build the paperback interior PDF'
task paperback: [:paperback_format, :paperback_publication, :paperback_manuscript, build_out] do
end


manuscript_source_dir = 'mss'
format_source_dir = 'format'
publication_source_dir = 'publication'

ebook_format_source_dir = "#{format_source_dir}/ebook"
ebook_publication_source_dir = "#{publication_source_dir}/ebook"

ebook_build_dir = "#{build_dir}/ebooks"
ebook_format_build_dir = ebook_build_dir
ebook_manuscript_build_dir = "#{ebook_build_dir}/mss"
ebook_publication_build_dir = ebook_build_dir

paperback_format_source_dir = "#{format_source_dir}/paperback"
paperback_manuscript_source_dir = "#{manuscript_source_dir}/tex"
paperback_publication_source_dir = "#{publication_source_dir}/paperback"

paperback_build_dir = "#{build_dir}/paperback"
paperback_format_build_dir = "#{paperback_build_dir}/format"
paperback_manuscript_build_dir = "#{paperback_build_dir}/mss"
paperback_publication_build_dir = paperback_build_dir

task ebook_format: [ebook_format_build_dir] do
  cp_r "#{ebook_format_source_dir}/.", ebook_format_build_dir
end

task ebook_manuscript: [ebook_manuscript_build_dir] do
  `tex2md #{paperback_manuscript_source_dir} #{ebook_manuscript_build_dir}`
end

task ebook_publication: [ebook_publication_build_dir] do
  cp_r "#{ebook_publication_source_dir}/.", ebook_publication_build_dir
end

task paperback_format: [paperback_format_build_dir] do
  cp_r "#{paperback_format_source_dir}/.", paperback_format_build_dir
  `cd #{paperback_format_build_dir} && rake`
end

task paperback_manuscript: [paperback_manuscript_build_dir] do
  cp_r "#{paperback_manuscript_source_dir}/.", paperback_manuscript_build_dir
end

task paperback_publication: [paperback_build_dir] do
  cp_r "#{paperback_publication_source_dir}/.", paperback_publication_build_dir
end

directory build_out
directory ebook_build_dir
directory ebook_format_build_dir
directory ebook_manuscript_build_dir
directory ebook_publication_build_dir
directory paperback_build_dir
directory paperback_format_build_dir
directory paperback_manuscript_build_dir
directory paperback_publication_build_dir

CLEAN << build_out
CLOBBER << build_dir
