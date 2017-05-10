# Load environment and do some environment checks
process.env.__VERSION = require('../package.json').version
require('dotenv').config()
if not require('fs').existsSync './.env'
	console.log('Warning: Could not load file ".env"')

# Vendor packages
express = require 'express'

# Initialize environment variables
PORT					     = process.env.PORT                = process.env.PORT					      or 3330
INFO_ROOT          = process.env.INFO_ROOT           = process.env.INFO_ROOT          or '/'
REQUESTS_ROOT      = process.env.REQUESTS_ROOT       = process.env.REQUESTS_ROOT      or '/webhooks'
GITHUB_ROOT        = process.env.GITHUB_ROOT         = process.env.GITHUB_ROOT        or '/github'
BITBUCKET_ROOT     = process.env.BITBUCKET_ROOT      = process.env.BITBUCKET_ROOT     or '/bitbucket'
GITHUB_SECRET      = process.env.GITHUB_SECRET       = process.env.GITHUB_SECRET      or 'github_secret'
URL_WEBHOOK_PREFIX = process.env.URL_WEBHOOK_PREFIX  = process.env.URL_WEBHOOK_PREFIX or 'by-secret/'

app = express()

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
console.log 'GitHub endpoint:', REQUESTS_ROOT + GITHUB_ROOT
console.log 'Bitbucket endpoint:', REQUESTS_ROOT + BITBUCKET_ROOT

