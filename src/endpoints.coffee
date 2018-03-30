path = require 'path'
fs = require 'fs'
bodyParser = require 'body-parser'

processSpawners = require('./process-spawner')

smartSpawn = processSpawners.smartSpawn

module.exports = (app, requestsEndpoint) ->
	app.locals.hooks = []

	app.use bodyParser.json
		type: 'application/json'

	app.use requestsEndpoint, (req, res, next) ->
		console.log 'Request Received:', req.url
		n = 0
		for hook in req.app.locals.hooks
			try
				if hook.checker req
					smartSpawn hook
					n += 1
			catch er
				null
		if n == 0
			# this may occur when we receive an invalid checkCallback()
			return next()
		else
			return res.status(200).send('Running ' + n + ' jobs.')

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

