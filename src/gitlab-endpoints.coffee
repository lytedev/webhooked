spawnProcess = require('./process-spawner').spawnProcess

module.exports = (req, res, next) ->
	if req.method != 'POST' then return next()

	console.log 'Gitlab Request: ', req.body

	n = 0
	for repo in app.locals.gitlaHooks
		if req.body.repository.name == repo.repositoryName
			n += 1
			scriptPath = path.resolve __dirname, './scripts/', repo.script
			ci = spawnProcess repo.exec, scriptPath,
	return res.status(200).send('Verified - Running ' + n + ' jobs...')

