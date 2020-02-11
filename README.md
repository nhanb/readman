# Dev

**DO NOT** run `nimble install`.

```sh
make deps # run once
ls * | entr -c make # run this in 1 terminal
echo server | entr -r ./server # run this in another terminal

# server should now be live on localhost:8080
```

# Notes so far:

## Routing

Is kinda shitty. Only supports hash routing out of the box via RouterData.
There's an example of proper pushState routing in nimforum but that's more
extra reading than I'm up for.
