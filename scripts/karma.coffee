# Track arbitrary karma
#
# <thing>++ - give thing some karma
# <thing>-- - take away some of thing's karma
# karma <thing> - check thing's karma (if <thing> is omitted, show the top 5)
# karma empty <thing> - empty a thing's karma
# karma best - show the top 5
# karma worst - show the bottom 5
class Karma

  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.karma
        @cache = @robot.brain.data.karma

  clear: ->
    @robot.brain.data.karma = @cache = {}

  kill: (thing) ->
    thing = @sanitize(thing)
    delete @cache[thing]
    @robot.brain.data.karma = @cache

  increment: (thing) ->
    thing = @sanitize(thing)
    @cache[thing] ?= 0
    @cache[thing] += 1
    @robot.brain.data.karma = @cache

  decrement: (thing) ->
    thing = @sanitize(thing)
    @cache[thing] ?= 0
    @cache[thing] -= 1
    @robot.brain.data.karma = @cache

  get: (thing) ->
    thing = @sanitize(thing)
    k = if @cache[thing] then @cache[thing] else 0
    return k

  sort: ->
    s = []
    for key, val of @cache
      s.push({ name: key, karma: val })
    s.sort (a, b) -> b.karma - a.karma

  top: (n = 5) ->
    sorted = @sort()
    sorted.slice(0, n)

  bottom: (n = 5) ->
    sorted = @sort()
    sorted.slice(-n).reverse()

  sanitize: (name) ->
    name.replace("@", "")

module.exports = (robot) ->
  karma = new Karma robot
  robot.hear /(\S+[^+\s])\s*\+\+(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    karma.increment subject

  robot.hear /(\S+[^-\s])\s*--(\s|$)/, (msg) ->
    subject = msg.match[1].toLowerCase()
    karma.decrement subject

  robot.respond /karma empty ?(\S+[^-\s])$/i, (msg) ->
    subject = msg.match[1].toLowerCase()
    karma.kill subject

  robot.respond /karma( best)?$/i, (msg) ->
    verbiage = ["The Best"]
    for item, rank in karma.top()
      verbiage.push "#{rank + 1}. #{item.name} - #{item.karma}"
    msg.send verbiage.join("\n")

  robot.respond /karma worst$/i, (msg) ->
    verbiage = ["The Worst"]
    for item, rank in karma.bottom()
      verbiage.push "#{rank + 1}. #{item.name} - #{item.karma}"
    msg.send verbiage.join("\n")

  robot.respond /karma (\S+[^-\s])$/i, (msg) ->
    match = msg.match[1].toLowerCase()
    if match != "best" && match != "worst"
      msg.send "\"#{match}\" has #{karma.get(match)} karma."

  robot.respond /karma clear \(yes\, I\'m sure\)/, (msg) ->
    karma.clear()
    msg.send "Ok, I've cleared ALL the karmas!"
