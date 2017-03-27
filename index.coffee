require('dotenv').config()

pkg = require './package.json'
express = require 'express'
bodyParser = require 'body-parser'

githubWebhookEndpoints = require './github-endpoints'

PORT = process.env.PORT or 3010

app = express()
app.use bodyParser.json()

app.get '/', (req, res, next) =>
	res.send 'lytedev/tiny-ci v' + pkg.version

githubWebhookEndpoints app

app.listen(PORT).on 'error', (err) ->
	console.log 'Express App Listen Error: Port', PORT, '\n', err
console.log "Listening on port", PORT
