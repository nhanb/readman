#!/usr/bin/bash

export JS_TEXT=$(cat client.js)
export CSS_TEXT=$(cat reset.css client.css)

cat client.html | envsubst >index.html
