include karax / prelude
include karax / [kajax, jjson]
import karax / kdom

type k = kstring

type State = object
  searching: bool

var state = State(
  searching: false
)


proc renderTabHeader(name: kstring, route: kstring, currentRoute: kstring): VNode =
  let activeClass =
    if route == currentRoute:
      k" active"
    else:
      k""
  result = buildHtml():
    a(class=k"tab-header" & activeClass, href=route):
      text name


proc renderMyLibraryPage(): VNode =
  result = buildHtml():
    h1(): text k"Working on it"


proc renderSearchPage(): VNode =
  result = buildHtml():
    form(action=k"/", `method`=k"POST"):
      tdiv(id=k"search-container"):
        input(id=k"search-input", `type`=k"text", name=k"query", placeholder=k"Enter manga title", required=k"required")
        button(
          id=k"search-button",
          `type`=k"submit",
          disabled = if state.searching: k"disabled" else: k(nil)
        ):
          if state.searching:
            span(class=k"spinner"): text k":"
            span: text k" searching"
          else: text k"search"

      proc onsubmit(ev: Event; n: VNode) =
        let query: kstring = document.querySelector(k"#search-input").value
        let data = %*{k"query": query}
        state.searching = true
        ajaxPost(
          url = k"/api/search",
          headers = [],
          data = data.toJson(),
          cont = proc (httpStatus: int, response: cstring) =
            kout(httpStatus)
            kout(response)
            state.searching = false
        )
        ev.preventDefault()


proc createDom(data: RouterData): VNode =
  let currentRoute =
    if data.hashPart == k"": k"#"
    else: data.hashPart

  result = buildHtml(tdiv):
    tdiv(id=k"tab-bar"):
      renderTabHeader(k"My Library", k"#", currentRoute)
      renderTabHeader(k"Search", k"#/search", currentRoute)
      renderTabHeader(k"Settings", k"#/settings", currentRoute)

    tdiv(id=k"tab-body"):
      if currentRoute == k"#":
        renderMyLibraryPage()
      elif currentRoute == k"#/search":
        renderSearchPage()
      else:
        button: text "TODO"

setRenderer createDom
