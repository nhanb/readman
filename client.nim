include karax / prelude
# alternatively: import karax / [kbase, vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils, jjson]

type Chapter = object
  name: kstring
  pages: seq[kstring]


var chapter = Chapter(
  name: kstring"A chapter",
  pages: @[
    kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x1.png",
    kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x2.png",
    kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x3.png",
    kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x4.png",
  ]
)

proc createDom(): VNode =
  result = buildHtml(tdiv):
    button:
      text chapter.name
    for url in chapter.pages:
      tdiv:
        img(src = url)

setRenderer createDom
