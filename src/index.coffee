# Load environment and do some environment checks
process.env.__VERSION = require('../package.json').version
require('dotenv').config()
if not require('fs').existsSync './.env'
	console.log('Warning: Could not load file ".env"')

# Vendor packages
express = require 'express'

# Initialize environment variables
PORT					     = process.env.PORT                = process.env.PORT					      or 3330
BASE_URL           = process.env.BASE_URL            = process.env.BASE_URL           or ''
INFO_ROOT          = process.env.INFO_ROOT           = process.env.INFO_ROOT          or BASE_URL + '/'
REQUESTS_ROOT      = process.env.REQUESTS_ROOT       = process.env.REQUESTS_ROOT      or BASE_URL + '/webhooks'
GITHUB_SECRET      = process.env.GITHUB_SECRET       = process.env.GITHUB_SECRET      or BASE_URL + 'github_secret'

app = express()

console.log "\n== lytedev/webhooked v" + process.env.__VERSION + " ==\n"

app.get INFO_ROOT, (req, res, next) =>
	res.send 'lytedev/webhooked v' + process.env.__VERSION
	return next()

require('./endpoints')(app, REQUESTS_ROOT)

# Start server
app.listen(PORT).on 'error', (err) ->
	console.log 'Express App Listen Error: Port', PORT, '\n', err

console.log 'Listening on port', PORT
console.log 'Info endpoint:', INFO_ROOT
console.log 'Requests endpoint:', REQUESTS_ROOT

