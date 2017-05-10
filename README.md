# webhooked

> A simple express server designed to receive and verify webhook requests and execute scripts.

Maybe.

I don't really know what I'm talking about.

## Setup

Install dependencies:

		npm install --global pm2 coffee-script
		yarn

Copy the example environment files and edit them:

		cp example.env .env
		cp example.env.endpoints.coffee .env.endpoints.coffee
		$EDITOR .env*

## Running

		npm run daemonize

## Stahp!

		npm run delete-daemon

## Reload

		npm run restart-daemon

## How it Works

* Setup your script that does the thing you want triggered
* Configure this app so that the right webhook endpoint triggers the right script
* Point the appropriate webhooks at the configured endpoint

## To Do

* Other webhook endpoints (GitLab, Slack?)
* Verify Bitbucket POST requests?
* Basic spam protection?
	* Configurable rate limiting?

