# Description:
#   Load the lib/*.json files into the Hubot's brain and environmental
#   variables from the .env file. Using _load to ensure this script is loaded 
#   first (alphabetical order).
#

# load .env if it exists...
require('dotenv').load();

# load internal JSON libraries
fs = require 'fs'

module.exports = (robot) ->
  getLibrary = (libName) ->
    buffer = fs.readFileSync "./lib/#{libName}.json"
    hash = buffer.toString()
    JSON.parse hash

  robot.brain.data["instructors"] = getLibrary("instructors")
  robot.brain.data["quotes"]      = getLibrary("quotes")
  robot.brain.data["students"]    = getLibrary("students")

  robot.router.get "/", (req, res) ->
    res.setHeader "Content-Type", "text/html"
    res.write fs.readFileSync("./lib/index.html").toString()
    res.end()