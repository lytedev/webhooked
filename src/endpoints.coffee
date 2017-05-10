path = require 'path'
fs = require 'fs'
bodyParser = require 'body-parser'

githubWebhookMiddleware = require './github-endpoints'
bitbucketWebhookMiddleware = require './bitbucket-endpoints'
simpleProcessSpawner = require('./process-spawner.coffee').simpleProcessSpawner

ENV_ENDPOINTS_FILE = path.resolve __dirname, '..', '.env.endpoints.coffee'

module.exports = (app, requestsEndpoint) =>
	app.locals.githubRepositoryNameHooks = []
	app.locals.bitbucketRepositoryNameHooks = []
	app.locals.urlIncludesHooks = []

	app.use bodyParser.json
		type: 'application/json'
	
	app.use path.join(requestsEndpoint, process.env.GITHUB_ROOT), githubWebhookMiddleware
	app.use path.join(requestsEndpoint, process.env.BITBUCKET_ROOT), bitbucketWebhookMiddleware

	app.use requestsEndpoint, (req, res, next) ->
		n = 0
		for hook in app.locals.urlIncludesHooks
			if req.url.includes(process.env.URL_WEBHOOK_PREFIX + hook.string)
				n += 1
				simpleProcessSpawner
					exec: 'bash'
					script: 'example-lytedev-hugo-site.bash'
		if n != 0
			res.status(200).send('Success')
		else
			return next()

	if fs.existsSync ENV_ENDPOINTS_FILE
		optionalEnvMiddleware = require(ENV_ENDPOINTS_FILE)(app, requestsEndpoint)
		if typeof(optionalEnvMiddleware) == 'function'
			app.use requestsEndpoint, optionalEnvMiddleware

	app.all '*', (req, res, next) ->
		return next()

