# Display a random "haters gonna hate" image
#
# haters - Returns a random haters gonna hate url
#
#
haters = [
  "http://d13pix9kaak6wt.cloudfront.net/background/chardot_1321720712_62.jpg"
]

hatin = (msg) ->
  msg.send msg.random haters

module.exports = (robot) ->
  robot.respond /haters/i, (msg) ->
    hatin msg
  robot.hear /heiters gonna heit/i, (msg) ->
    hatin msg
