# Description:
#   Load the lib/*.json files into the Hubot's brain.
#

fs = require 'fs'

module.exports = (robot) ->
  getLibrary = (libName) ->
    buffer = fs.readFileSync "./lib/#{libName}.json"
    hash = buffer.toString()
    JSON.parse hash
  #TODO compress by setting encoding
  robot.brain.data["instructors"] = getLibrary("instructors")
  robot.brain.data["quotes"]      = getLibrary("quotes")
  robot.brain.data["students"]    = getLibrary("students")
