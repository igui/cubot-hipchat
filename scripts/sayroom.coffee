# Send a message to a room
#
# Usage
#
# sayroom <room> <message>

module.exports = (robot) ->
  robot.respond /sayroom\s+(\w+)\s+(.+)$/i, (msg) ->
    room = msg.match[1]
    message = msg.match[2]

    try
      robot.messageRoom(room, message)
    catch error
      msg.send "Couldn't send message to room"
      throw "#{error}'\n#{error.stack}"
