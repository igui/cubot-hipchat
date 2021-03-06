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

  herotext = "Not the hero we deserve, but the hero we need right now"

  heroes = [
    "#{herotext} http://s3.amazonaws.com/uploads.hipchat.com/13028/42886/vshhuyh6tyxtrks/captaintrott.jpg",
    "#{herotext} http://s3.amazonaws.com/uploads.hipchat.com/13028/44323/smmlcnpwa091y3v/Hero.jpg",
    "#{herotext} http://s3.amazonaws.com/uploads.hipchat.com/13028/44323/8wihe5s5y4iz8p3/Pancakes.jpg"
  ]

  robot.hear /\bhero\b/i, (msg) ->
    msg.send msg.random heroes
