path = require 'path'
# xhub = require 'express-x-hub'
crypto = require 'crypto'
bodyParser = require 'body-parser'
spawnProcess = require('./process-spawner').spawnProcess

getHubSignature = (data, secret, enc = 'utf-8') ->
	hmac = crypto.createHmac 'sha1', secret
	hmac.update data, enc
	return 'sha1=' + hmac.digest('hex')

verifyHubSignature = (xsig, data, secret, enc = 'utf-8') ->
	sig = getHubSignature data, secret, enc
	return sig == xsig

verifyHubSignatureRequest = (req) ->
	return verifyHubSignature(req.header('x-hub-signature'), JSON.stringify(req.body), process.env.GITHUB_SECRET)

module.exports = (app) ->
	app.use bodyParser.json
		type: 'application/json'

	app.post '/github-webhook', (req, res, next) =>
		if not verifyHubSignatureRequest(req)
			console.log '/github-webhook failed to verify a request containing X-Hub-Signature'
			return next()

		if req.body.repository.full_name == 'lytedev/lytedev.github.io'
			scriptPath = path.resolve __dirname, './scripts/', 'lytedev-hugo-site.bash'
			ci = spawnProcess 'bash', scriptPath, (procInfo) ->
				res.send JSON.stringify procInfo.code

	# app.use bodyParser.json()

