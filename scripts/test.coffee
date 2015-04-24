# Description:
#   TODO 
#

module.exports = (robot) ->

	robot.hear /^test(ing)?$/i, (msg) ->
		console.log "brain: #{JSON.stringify robot.brain.data}"
		console.log "envelope: #{JSON.stringify msg.envelope}"