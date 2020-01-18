all: server client.js

client.js: client.nim
	nim js client.nim

server: server.nim
	nim c server.nim

deps: readman.nimble
	nimble install -d

clean:
	rm -f client.js
