# To Do

## To build an ebook

1. Copy format/ebook/* to build/ebook
1. Copy publication/ebook/* to build/ebook
1. Copy publication/title.yaml to build/ebook
1. tex2md mss/tex to build/ebook/mss
1. In build/ebook, rake all
1. Copy build/ebook/slug.epub to upload/slug.epub
1. Copy build/ebook/slug-no-cover.mobi to upload/slug.mobi

## To build a paperback

1. Copy format/paperback/* to build/paperback-format
1. Build build/paperback-format to build/paperback/dbp.tex (maybe not)
1. Copy publication/paperback/* to build/paperback
1. Translate publication/title.yaml to build/paperback/mss.tex
1. In build/paperback, rake all
1. Copy build/paperback/slug.pdf to upload/slug.pdf

Questions:
- Do I need to build dbp.tex?
    - I could just input the format file directly.
    - And I could symlink build/format -> format/paperback

## ebook-template/Rakefile

1. Build and check slug.epub
1. Build and check slug-no-cover.epub
1. Build mobi from slug-no-cover.epub

## paperback-template/Rakefile

1. Build slug.pdf
