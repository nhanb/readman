import asynchttpserver, asyncdispatch, asyncfile, json
import karax / [kbase]
import api


proc serveRpc(req: Request) {.async.} =
  if req.reqMethod != HttpPost:
    await req.respond(Http400, "This endpoint only suports POST requests.")
    return

  try:
    var bodyJson = parseJson(req.body)
    let rpcMethod = bodyJson["method"].getStr()
    let rpcParams = bodyJson["params"]

    case rpcMethod
    of "get-chapter":
      let chapterId = to(rpcParams, GetChapterRequest).id
      if chapterId == "84749":
        let headers = newHttpHeaders([("Content-Type", "application/json")])
        let chapter = Chapter(
          name: kstring"Kaiman",
          pages: @[
            kstring"https://s2.mangadex.org/data/a02dc29634d4c2b1afd7ed27a2cb556a/x1.jpg",
            kstring"https://s2.mangadex.org/data/a02dc29634d4c2b1afd7ed27a2cb556a/x2.jpg",
            kstring"https://s2.mangadex.org/data/a02dc29634d4c2b1afd7ed27a2cb556a/x3.jpg",
          ]
        )
        await req.respond(Http200, $(%*chapter), headers)
      else:
        await req.respond(Http404, "Chapter not found")

    else:
      await req.respond(Http400, "Invalid RPC method")

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

  of "/api":
    await serveRpc(req)

  of "/logo.svg":
    await req.serveStaticFile("logo.svg", "image/svg+xml")

  else:
    # Instead of 404, serve default HTML so client-side SPA routing takes over:
    await req.serveStaticFile("index.html", "text/html")

const port = 8080
echo "Starting server at http://localhost:", port
waitFor server.serve(Port(port), cb)
