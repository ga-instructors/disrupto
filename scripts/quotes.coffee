# Description:
#   TODO 
#

fs = require 'fs'

module.exports = (robot) ->

	robot.respond /quote me/i, (msg) ->
		msg.send msg.random robot.brain.data.quotes
