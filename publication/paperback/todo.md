# To Do

## Manuscript

### Content Files

- translated
    from `mss/tex`
    to `build/paperback/mss`
    by `tex2md`

### Spine

A listing of the content files in proper reading order.

- translated
    from `mss/spine.txt`
    to `build/paperback/spine.tex`
    by `sed`

### spine.txt

Example `mss/spine.txt`:

~~~
introduction
carrion-road/chapter-01
carrion-road/chapter-02
carrion-road/chapter-03
~~~

Example `build/paperback/spine.tex`

~~~
\input mss/introduction
\input mss/carrion-road/chapter-01
\input mss/carrion-road/chapter-02
\input mss/carrion-road/chapter-03
~~~

### Text or YAML?

- If I make it text, it stays simple.
- If I make it YAML, I can add metadata to each file:
    - Title
    - Style (book, chapter, scene)
    
