# Apply golaroid effect to the picture
#
# effect http://host.com/picture.jpg
module.exports = (robot) ->
  robot.hear /([\d\w]+) effect (.+)/, (msg) ->
    filter = msg.match[1].toLowerCase()
    pic = msg.match[2]
    msg.send "http://golaroid.herokuapp.com/filter?f=#{filter}&pic=#{pic}"