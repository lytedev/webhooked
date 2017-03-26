require('dotenv').config()

pkg = require './package.json'
express = require 'express'

endpoints = require './endpoints'

PORT = process.env.PORT or 3010

app = express()

app.get '/ci/', (req, res, next) =>
	res.send 'lytedev/tiny-ci v' + pkg.version

endpoints app

app.listen(PORT).on 'error', (err) ->
	console.log 'Express App Listen Error: Port', PORT, '\n', err
console.log "Listening on port", PORT
