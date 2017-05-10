crypto = require 'crypto'

###*
# Creates an HMAC digest in hex format of the given data using the provided
# secret.
# @param {string} data
# @param {string} secret
# @param {string} [enc=utf-8]
# @returns {string} HMAC digest in format 'sha1=HMAC' where HMAC is
# the hexadecimal-encoded HMAC digest.
###
getHubSignature = (data, secret, enc = 'utf-8') ->
	hmac = crypto.createHmac 'sha1', secret
	hmac.update data, enc
	return 'sha1=' + hmac.digest('hex')

###*
# Verifies the expected signature of a data set.
# @param {string} xsig - The expected signature.
# @param {string} data
# @param {string} secret
# @param {string} [enc=utf-8]
# @returns {bool}
###
verifyHubSignature = (xsig, data, secret, enc = 'utf-8') ->
	sig = getHubSignature data, secret, enc
	return sig == xsig

###*
# Verifies the signature of an Express request and flags it accordingly.
# @param {object} req - An express request.
# @param {string} secret
###
verifyHubSignatureRequest = (req, secret) ->
	retval = verifyHubSignature(req.header('x-hub-signature'), JSON.stringify(req.body), secret)
	req.isVerifiedHubRequest = req
	return retval

module.exports = verifyHubSignatureRequest
