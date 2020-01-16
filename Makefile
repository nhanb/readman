all: main.js main

main:
	nim c -d:nerveServer main.nim

main.js:
	nim js -d:nerveClient main.nim

deps:
	nimble install -d

clean:
	rm -f main main.js
