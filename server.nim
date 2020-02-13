import asynchttpserver, asyncdispatch, asyncfile, json


proc serveSearch(req: Request) {.async.} =
  if req.reqMethod != HttpPost:
    await req.respond(Http400, "This endpoint only suports POST requests.")
    return

  try:
    var bodyJson = parseJson(req.body)
    let query = bodyJson["query"].getStr()
    await req.respond(
      Http200,
      $(%*{"result": query}),
      newHttpHeaders([("Content-Type", "text/plain")])
    )

  except JsonParsingError:
    await req.respond(Http400, "Malformed RPC request payload")


proc serveStaticFile(req: Request, filename: string, contentType: string) {.async.} =
  var file = openAsync(filename, fmRead)
  let data = await file.readAll()
  file.close()
  let headers = newHttpHeaders([("Content-Type", contentType)])
  await req.respond(Http200, data, headers)


var server = newAsyncHttpServer()

proc cb(req: Request) {.async.} =
  case req.url.path

  of "/api/search":
    await serveSearch(req)

  of "/logo.svg":
    await req.serveStaticFile("logo.svg", "image/svg+xml")

  else:
    # Instead of 404, serve default HTML so client-side SPA routing takes over:
    await req.serveStaticFile("index.html", "text/html")

const port = 8080
echo "Starting server at http://localhost:", port
waitFor server.serve(Port(port), cb)
