path = require 'path'
spawnProcess = require('./process-spawner').spawnProcess
createGithubWebhookHandler = require 'github-webhook-handler'

handler = createGithubWebhookHandler
	path: '/github-webhook'
	secret: process.env.GITHUB_SECRET

module.exports = (app) ->
	app.use handler

	handler.on 'push', (ev) ->
		if ev.payload.repository.full_name == 'lytedev/lytedev.github.io'
			scriptPath = path.resolve __dirname, './scripts/', 'lytedev-hugo-site.bash'
			ci = spawnProcess 'bash', scriptPath


	# app.post '/lytedev-hugo-site', (req, res, next) =>
	# 	scriptPath = path.resolve __dirname, './scripts/', 'lytedev-hugo-site.bash'
	# 	ci = spawnProcess 'bash', scriptPath
