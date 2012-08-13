# Consult the ruby documentation
#
# ri <expr> - passes the expression to ri and returns the result

exec = require("child_process").exec

module.exports = (robot) ->
  robot.respond /ri (.+)/, (msg) ->
    console.log "match!"
    exec "ri #{msg.match[1]}", (err, stdout, stderr) ->
      console.log "================================================================================"
      console.log err
      console.log "================================================================================"
      console.log stdout
      console.log "================================================================================"
      console.log stderr
      console.log "================================================================================"
      msg.send stdout
