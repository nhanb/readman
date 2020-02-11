all: server index.html

index.html: client.html client.js client.css reset.css
	./build-index.sh

client.js: client.nim
	nim js client.nim

server: server.nim
	nim c server.nim

deps: readman.nimble
	nimble install -d

clean:
	rm -f *.js index.html server
