import asynchttpserver, asyncdispatch, asyncfile

const STATIC_PATHS = [
  "/",
  "/client.js",
]

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  if req.url.path in STATIC_PATHS:
    var fileName = req.url.path[1..^1] # remove leading slash
    if fileName == "":
      fileName = "client.html"
    var file = openAsync(fileName, fmRead)
    let data = await file.readAll()
    file.close()
    await req.respond(Http200, data)

  else:
    await req.respond(Http404, "Nothing to see here.")

waitFor server.serve(Port(8080), cb)
