require('dotenv').config()

pkg = require './package.json'
express = require 'express'

githubWebhookEndpoints = require './github-endpoints'

PORT = process.env.PORT or 3010
INFO_ROOT = process.env.INFO_ROOT or '/'
REQUESTS_ROOT = process.env.PORT or '/'

app = express()

app.get INFO_ROOT, (req, res, next) =>
	res.send 'lytedev/tiny-ci v' + pkg.version

app.group REQUESTS_ROOT, (router) ->
	githubWebhookEndpoints router

app.listen(PORT).on 'error', (err) ->
	console.log 'Express App Listen Error: Port', PORT, '\n', err
console.log "Listening on port", PORT
