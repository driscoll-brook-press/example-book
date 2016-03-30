require 'rake/clean'
require 'pathname'

manuscript_source_dir = 'mss'
format_source_dir = 'format'
publication_source_dir = 'publication'

paperback_format_source_dir = "#{format_source_dir}/paperback"
paperback_manuscript_source_dir = "#{manuscript_source_dir}/tex"
paperback_publication_source_dir = "#{publication_source_dir}/paperback"

build_dir = 'build'
build_out = "#{build_dir}/out"

paperback_build_dir = "#{build_dir}/paperback"
paperback_format_build_dir = "#{paperback_build_dir}/format"
paperback_manuscript_build_dir = "#{paperback_build_dir}/mss"

ebook_build_dir = "#{build_dir}/ebooks"

directory build_out
directory ebook_build_dir
directory paperback_build_dir
directory paperback_format_build_dir
directory paperback_manuscript_build_dir

task default: :all

desc 'Build all formats'
task all: [:ebooks, :paperback]

desc 'Build all ebook formats'
task ebooks: [:ebook_build_files, build_out]

desc 'Build the paperback interior PDF'
task paperback: [:paperback_build_files, build_out]

task ebook_build_files: [ebook_build_dir]

task paperback_build_files: [:paperback_format_build_files, :paperback_publication_build_files, :paperback_manuscript_build_files]

task paperback_format_build_files: [paperback_format_build_dir] do
  cp_r "#{paperback_format_source_dir}/.", paperback_format_build_dir
end

task paperback_publication_build_files: [paperback_build_dir] do
  cp_r "#{paperback_publication_source_dir}/.", paperback_build_dir
end

task paperback_manuscript_build_files: [paperback_manuscript_build_dir] do
  cp_r "#{paperback_manuscript_source_dir}/.", paperback_manuscript_build_dir
end

CLEAN << build_out
CLOBBER << build_dir
