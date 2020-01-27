# Markdown Cheatsheet

## Headers

```
# H1
## H2
### H3
#### H4
##### H5
###### H6

Alternatively, for H1 and H2, you can do an underline-ish style:

Alt-H1
======

Alt-H2
------
```

# H1
## H2
### H3
#### H4
##### H5
###### H6

Alternatively, for H1 and H2, you can do an underline-ish style:

Alt-H1
======

Alt-H2
------


## Tables

Note: Tables aren't part of the core Markdown spec, but they are part of GFM and _Markdown Here_ supports them.

There must be at least 3 dashes separating each leader cell.
Colons placed on the dash lines can be used to align columns.

The outer pipes (|) are optional.
You don't need to make the raw Markdown line up prettily.
You can also use inline Markdown.

Leader cell titles are always bolded.

```
| Tables        | Are            | Cool  |
| ------------- |:--------------:| -----:|
| Col 2 is      | center-aligned | $1600 |
| Col 3 is      | right-aligned  |   $16 |
| zebra stripes | are neat       |    $1 |
```

| Tables        | Are            | Cool  |
| ------------- |:--------------:| -----:|
| Col 2 is      | center-aligned | $1600 |
| Col 3 is      | right-aligned  |   $16 |
| zebra stripes | are neat       |    $1 |

```
Less | Pretty | Markdown 
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
```

Less | Pretty | Markdown 
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3

## Links

There are two ways to create links.

```
[I'm an inline-style link](https://www.google.com)

[I'm an inline-style link with title](https://www.google.com "Google's Homepage")

[I'm a reference-style link][Arbitrary case-insensitive reference text]

[I'm a relative reference to a repository file](../blob/master/LICENSE)

[You can use numbers for reference-style link definitions][1]

Or leave it empty and use the [link text itself].

URLs and URLs in angle brackets will automatically get turned into links. 
http://www.example.com or <http://www.example.com> and sometimes 
example.com (but not on Github, for example).

Some text to show that the reference links can follow later.

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: http://www.reddit.com
```

[I'm an inline-style link](https://www.google.com)

[I'm an inline-style link with title](https://www.google.com "Google's Homepage")

[I'm a reference-style link][Arbitrary case-insensitive reference text]

[I'm a relative reference to a repository file](../blob/master/LICENSE)

[You can use numbers for reference-style link definitions][1]

Or leave it empty and use the [link text itself].

URLs and URLs in angle brackets will automatically get turned into links.
http://www.example.com or <http://www.example.com> and sometimes
example.com (but not on Github, for example).

Some text to show that the reference links can follow later.

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: http://www.reddit.com
