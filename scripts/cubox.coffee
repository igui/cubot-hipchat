exec = require('child_process').exec

module.exports = (robot) ->
  robot.hear /coso/i, (msg) ->
    msg.send "coso coso psicodelia!!"

  robot.respond /send (.+) to ((\S ?)+|everybody|all)$/i, (msg) ->
    subject = msg.match[1]

    recipient = msg.match[2]

    if recipient == 'everybody' || recipient == 'all'
        recipient = 'todos@cuboxlabs.com' 
        msg.send "Ok. I'll send to all the cuboxers (allthethings)"
    else
        msg.send "Ok"

    exec "gmail -t #{recipient} -s '#{subject}' -c ''", (error, stdout, stderr) ->
      if !error
        msg.send "I just sent an email to #{recipient} with subject '#{subject}'"
      else
        msg.send "Oops, something went wrong #{error}"

  robot.hear /hero/i, (msg) ->
    msg.send "Not the hero we deserve, but the hero we need right now"
    msg.send "http://farm8.staticflickr.com/7143/6523210745_e0f54ba363_b.jpg"
