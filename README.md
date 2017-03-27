# webhooked

> A simple express server designed to receive and verify webhook requests and execute scripts.

Maybe.

I don't really know what I'm talking about.

## To Do

* Simple configuration system? (map endpoints or certain body variables to
	scripts?)
* Other webhook endpoints (GitLab, Bitbucket, Slack?)
* Flesh out the build system (so that scripts and even the `package.json` don't
	need to be copied - yuck!)

## Setup

* `npm install --global pm2 coffee-script` (you may need to run as root)
* `npm run daemonize`

Also edit the `example.env` and save your copy as `.env`.

## Stahp!

* `npm run delete-daemon`

## How it Works

Simply point a webhook at this server and have it trigger the script that
properly pulls down the code or whatever.

Also check secrets and whatnot... someday.
