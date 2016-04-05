# To Do

## Rakefile

- Rebuild only when necessary
    - Probably via a dependency on `package.opf`
- Build zip from common ebook content where possible
- Epub details.
- Build mobi file from coverless epub.

## Build common files

- Run jekyll, excluding toc.ncx, package.opf, and cover

## Build epub files

- Run jekyll, including only toc.ncx, package.opf, and cover

## Build mobi files

- Run jekyll, including only toc.ncx and package.opf
