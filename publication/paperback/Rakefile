require 'rake/clean'

slug = 'book'
fmt_name = 'dbp'

tex_file = "#{slug}.tex"
pdf_file = "#{slug}.pdf"
log_file = "#{slug}.log"

task default: [:clean, :build, :log, :show]

file pdf_file

desc 'Typeset the book as a PDF file'
task :build do
  `pdftex -interaction=batchmode -fmt #{fmt_name} #{tex_file}`
end

desc 'Show the PDF file'
task :show do
  `open #{pdf_file}`
end

desc 'Show the log file'
task :log do
  print `cat #{log_file}`
end

CLEAN << pdf_file
CLEAN << log_file
