# That is what she said - Replies appropiately to the 'that is what she said' meme
#
module.exports = (robot) ->
  robot.hear /that is what she said/i, (msg) ->
    msg.send "That is what your mom said... last night."
