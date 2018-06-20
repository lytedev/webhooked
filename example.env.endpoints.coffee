path = require 'path'

module.exports = (app, requestsEndpoint, srcDir) ->

	# Environment variables should be configured with `.env`. See `example.env`
	# for an example.

	# This will cause the 'count-to-ten.bash' script to be executed by 'bash' when
	# any incoming request URL contains the specified string (SECRET_WEBHOOK_ID).
	# This allows for easily specifying "manual" webhooks. Be sure to use a long
	# and random string here and keep it secret so that you don't get DDoS'd!
	app.locals.hooks.push
		# if checker(req) evaluates to true, the script will be called
		checker: (req) -> req.url.includes(process.env.SECRET_WEBHOOK_ID)
		exec: 'bash'
		script: 'count-to-ten.bash'
		noDedup: true
		# noDedup: true lets more than one instance of the job be active at any time
		# you shouldn't probably ever really need this

	# The module that this file exports may return Express middleware to be used
	return (req, res, next) ->
		if req.method == 'GET' and req.url.includes('99-bottles-of-beer')
			return res.status(200).send('98 bottles of beer on the wall, now, friend!')
		else
			next()

