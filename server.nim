import asynchttpserver, asyncdispatch, asyncfile, json, api
import karax / [kbase] # to use kstring


var server = newAsyncHttpServer()

proc cb(req: Request) {.async.} =
  case req.url.path
  # serve static files:
  of "/client.js":
    # TODO: I may want to inline everything into a single html file
    var file = openAsync("client.js", fmRead)
    let data = await file.readAll()
    file.close()
    let headers = newHttpHeaders([("Content-Type", "text/javascript")])
    await req.respond(Http200, data, headers)

  # TODO json-rpc endpoint:
  of "/api":
    let headers = newHttpHeaders([("Content-Type", "application/json")])
    let chapter = Chapter(
      name: kstring"A chapter",
      pages: @[
        kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x1.png",
        kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x2.png",
        kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x3.png",
        kstring"https://s2.mangadex.org/data/dcc142a8abe2f790962db8215c7bf77b/x4.png",
      ]
    )
    await req.respond(Http200, $(%*chapter), headers)

  else:
    # Instead of 404, serve default HTML so client-side SPA routing takes over:
    var file = openAsync("client.html", fmRead)
    let data = await file.readAll()
    file.close()
    let headers = newHttpHeaders([("Content-Type", "text/html")])
    await req.respond(Http200, data, headers)

waitFor server.serve(Port(8080), cb)
