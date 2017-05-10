spawnProcess = require('./process-spawner').spawnProcess

verifyBitbucketRequest = (req) =>
	# TODO: Bitbucket currently has no verification system
	retval = true
	req.isVerifiedBitbucketRequest = retval
	return retval

module.exports = (req, res, next) ->
	if req.method != 'POST' then return next()
	isVerified = verifyBitbucketRequest req
	req.isVerifiedBitbucketRequest = isVerified

	if isVerified
		n = 0
		for repo in req.app.locals.bitbucketRepositoryNameHooks
			if req.body.repository.full_name == repo.repositoryFullName
				n += 1
				scriptPath = path.resolve __dirname, './scripts/', repo.script
				ci = spawnProcess repo.exec, scriptPath,
					onExit: (procInfo) ->
						res.send JSON.stringify procInfo.code
		if n == 0
			return res.status(200).send('No scripts to run')
		else
			return res.status(200).send('Verified - Running ' + n + ' jobs...')
	else
		return res.status(400).send('Failed to verify hub signature')

