path = require 'path'
spawnProcess = require('./process-spawner').spawnProcess

module.exports = (app) ->
	app.get '/ci/lytedev-hugo-site', (req, res, next) =>
		p = path.resolve(__dirname, './scripts/', 'lytedev-hugo-site.bash')
		console.log __dirname, p
		ci = spawnProcess 'bash', [p], undefined, (process, args, proc, stdout, stderr, code) =>
			res.send JSON.stringify code
