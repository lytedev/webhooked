spawnProcess = require('./process-spawner').spawnProcess
verifyGitHubSignatureRequest = require './verify-signature'

module.exports = (req, res, next) =>
	if req.method != 'POST' then return next()
	isVerified = verifyGitHubSignatureRequest(req, process.env.GITHUB_SECRET)
	req.isVerifiedGutHubRequest = isVerified

	if isVerified
		n = 0
		for repo in app.locals.githubRepositoryNameHooks
			if req.body.repository.full_name == repo.repositoryFullName
				n += 1
				scriptPath = path.resolve __dirname, './scripts/', repo.script
				ci = spawnProcess repo.exec, scriptPath,
		return res.status(200).send('Verified - Running ' + n + ' jobs...')
	else
		return res.status(400).send('Failed to verify hub signature')

