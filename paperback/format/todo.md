## Font Sizes

- Given a typeface and a font size,
    calculate the appropriate optical size ftag.

## Line Breaking

Specify reasonable values for the line-breaking parameters.

## Trim Sizes

*Note: I do not need this yet.
YAGNI?*

- 5in-x-8in.tex

## Baselinebox

- `\baselinebox#1`: Aligns its content to a baseline.
    - Adds enough depth to position the subsequent box.
    - If natural depth exceeds maxdepth, add `\leading` to its depth.
    - Assume no glue top and bottom?

## Block Quotes

Some way to vertically center a block quote in a space that positions the subsequent box.

## Heading Parameters

Chapter heading:

    - `\chapterheadingalignment`
    - `\chapterheadingprefix`
    - `\chapterheadingsuffix`
    - `\chaptertitlefont`

## Title Formatting

- Discourage full width book titles
    - and perhaps headings

## Word Spacing

    - min 1/5em
    - normal 1/4em
    - max 1/3em
