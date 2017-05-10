path = require 'path'

simpleProcessSpawner = require('./src/process-spawner.coffee').simpleProcessSpawner

module.exports = (app) ->

	# This will cause the 'example-lytedev-hugo-site.bash' script to be executed
	# by 'bash' when any webhook request comes in where the repository.full_name
	# matches the repositoryFullName here.
	app.locals.githubRepositoryNameHooks.push
		repositoryFullName: 'lytedev/lytedev.github.io'
		exec: 'bash'
		script: 'example-lytedev-hugo-site.bash'

	# This will cause the 'example-lytedev-hugo-site.bash' script to be executed
	# by 'bash' when any incoming request contains the specified string prefixed
	# with HOOKID_PREFIX. This allows for easily specifyin "manual" webhooks. Be
	# sure to use a long and random string here and keep it secret so that you
	# don't get DDoS'd!

	app.locals.urlIncludesHooks.push
		string: process.env.SECRET_WEBHOOK_ID
		exec: 'bash'
		script: 'example-lytedev-hugo-site.bash'

	# The module that this file exports may return Express middleware to be used
	return (req, res, next) ->
		if req.method == 'POST' and req.url.includes('99-bottles-of-beer')
			return res.status(200).send('98 bottles of beer on the wall, now')
		else
			next()
