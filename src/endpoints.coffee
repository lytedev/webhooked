path = require 'path'
fs = require 'fs'
bodyParser = require 'body-parser'

githubWebhookMiddleware = require './github-endpoints'
bitbucketWebhookMiddleware = require './bitbucket-endpoints'
processSpawners = require('./process-spawner')

simpleProcessSpawner = processSpawners.simpleProcessSpawner
dedupProcessSpawner = processSpawners.dedupProcessSpawner

module.exports = (app, requestsEndpoint) ->
	app.locals.githubRepositoryNameHooks = []
	app.locals.bitbucketRepositoryNameHooks = []
	app.locals.urlIncludesHooks = []

	app.use bodyParser.json
		type: 'application/json'
	
	app.use path.join(requestsEndpoint, process.env.GITHUB_ROOT), githubWebhookMiddleware
	app.use path.join(requestsEndpoint, process.env.BITBUCKET_ROOT), bitbucketWebhookMiddleware

	app.use requestsEndpoint, (req, res, next) ->
		console.log 'Webhook Request:', req.url
		n = 0
		for hook in req.app.locals.urlIncludesHooks
			if req.url.includes(process.env.URL_WEBHOOK_PREFIX + hook.string)
				n += 1
				if hook.noDedup? and hook.noDedup
					simpleProcessSpawner hook
				else
					dedupProcessSpawner hook
		if n != 0
			res.status(200).send('Success')
		else
			return next()

	try
		optionalEnvMiddleware = require('../.env.endpoints')(app, requestsEndpoint, __dirname)
		if typeof(optionalEnvMiddleware) == 'function'
			console.log 'Custom Middleware Installed'
			app.use requestsEndpoint, optionalEnvMiddleware
	catch err
		console.log 'Warning: Failed to require the ".env.endpoints{.coffee,.js}" file.', err
		null

	app.all '*', (req, res, next) ->
		return next()

