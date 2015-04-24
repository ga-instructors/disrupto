# Description:
#   Allows students to queue for help and for instructors and TAs to pull 
#   students from the queue.
#
# Dependencies:
#   "lodash-node": "^3.7.0"
#   "moment": "^2.9.0"
#   "moment-timezone": "^0.3.0"
# 
# Configuration:
#   None
#
# Commands:
#   hubot queue me for <reason> - Adds you to the queue
#   hubot unqueue me - Removes you to the queue
#   hubot (student) queue - Replies the current state of the queue
#   hubot queue len(gth) - Replies with the length of the queue
#   hubot pop (student) - Removes the next student from queue [admin]
#   hubot empty queue - Empties the queue [admin]
#
# Notes:
#    * The "queue" is stored in the bot's brain under:
#      - `robot.brain.data.studentQueue`
#      - `robot.brain.data.poppedStudents`
#    * To restrict "popping" a student off the queue, ensure that there is a 
#      list of authorized users stored in the brain in the array:
#      - `robot.brain.data.instructors`
#

# TODO: Add a dependency for cron, and set the queue to empty at 4am every day...
# TODO: strengthen the regexes, especially `q` and `pop`; build in hubot name catcher

_      = require "lodash-node"
moment = require "moment"

formatTime = (time) -> moment(time).format 'MMM Do, h:mm:ss a'

module.exports = (robot) ->

  # SETUP ######################################################################
  robot.brain.data.studentQueue   ?= []
  robot.brain.data.poppedStudents ?= [] # store for past student issues
  
  studentQueue   = robot.brain.data.studentQueue
  poppedStudents = robot.brain.data.poppedStudents

  queueStudent = (name, reason) ->
    studentQueue.push
      name:     name
      queuedAt: new Date()
      reason:   reason

  popStudent = (name, popped = true) ->
    student = studentQueue.shift()
    student.poppedAt = new Date()
    student.poppedBy = name
    student.handled  = popped
    poppedStudents.push student
    student

  stringifyQueue = ->
    str = _.reduce studentQueue, (reply, stud) ->
        "\n#{stud.name} at #{formatTime stud.queuedAt} for #{stud.reason}"
      , ""
    "Current queue is: #{str}"

  authorized = (name) ->
    instructors = robot.brain.data.instructors
    !(instructors && ! _.includes(instructors, name))

  # USAGE SUPPORT ##############################################################
  robot.respond /q(ueue)? me$/i, (res) ->
    res.reply "usage: bot queue me for [reason]"

  robot.respond /q(ueue)? me(.+)/i, (res) ->
    unless res.match[2].match /^[ ]*for (.+)/i
      res.reply "usage: bot queue me for [reason]"

  # RESPONSES ##################################################################
  robot.respond /q(ueue)? me for (.+)/i, (res) ->
    name   = res.envelope.user.real_name
    reason = res.match[2]

    if _.any(studentQueue, (student) -> student.name == name)
      res.send "#{name} is already queued"
    else
      queueStudent name, reason
      res.send stringifyQueue()

  robot.respond /unq(ueue)? me/i, (res) ->
    name = res.envelope.user.real_name

    if _.any(studentQueue, (student) -> student.name == name)
      studentQueue = _.filter studentQueue, (student) ->
        student.name != name
      res.reply "OK, you're removed from the queue."
    else
      res.reply "You weren't in the queue."

  robot.respond /// (student )?q(ueue)?$///i, (res) ->
    if _.isEmpty studentQueue
      res.send "Student queue is empty"
    else
      res.send stringifyQueue()

  robot.respond /// pop(  student)?$///i, (res) ->
    unless authorized(res.message.user.name)
      res.reply "Sorry, you do not have permission to do that!"
      return

    if _.isEmpty studentQueue
      res.send "Student queue is empty."
    else
      student = popStudent(res.envelope.user.real_name)
      res.reply "Help #{student.name} with #{student.reason}, " + 
        "queued at #{formatTime student.queuedAt}"      

  robot.respond /empty q(ueue)?/i, (res) ->
    unless authorized(res.message.user.name)
      res.reply "Sorry, you do not have permission to do that!"
      return

    studentQueue.forEach ->
      popStudent(res.envelope.user.real_name, false)

    res.reply "Queue emptied!"

  robot.respond /q(ueue)?[ .]len(gth)?/i, (res) ->
    _.tap studentQueue.length, (length) ->
      res.send "Current queue length is #{length} students."

  # ROUTES #####################################################################
  robot.router.get "/queue/current", (req, res) ->
    res.json studentQueue

  robot.router.get "/queue/popped", (req, res) ->
    res.json poppedStudents
