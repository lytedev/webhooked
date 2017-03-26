# tiny-ci

> A dead-simple, super tiny, webhook-based CI tool.

Maybe.

I don't really know what I'm talking about.

## Setup

* `npm install --global pm2 coffee-script` (you may need to run as root)
* `npm run daemonize`

## Stahp!

* `npm run delete-daemon`

## How it Works

Simply point a webhook at this server and have it trigger the script that
properly pulls down the code or whatever.

Also check secrets and whatnot... someday.
