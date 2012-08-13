# Manage automatically linking things. Automatically will replace #25 for the
# link to issue #25, if a pattern for autolinking issues has been stored.
#
# Will also autolink commits if you defined a pattern for that, matching any
# 6-41 hexanumerical word.
#
# autolink <issues|commits> to <pattern> - Store the pattern for issue/commit links. Use :number/:sha for the pattern.

class Autolinker
  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on "loaded", =>
      if @robot.brain.data.auto_links
        for room, links of @robot.brain.data.auto_links
          @cache[room] = links.map (d) -> Pattern.fromHash(d)

  remember: (room, pattern) ->
    @_store(room, pattern)

  link: (room, pattern, value) ->
    if pattern = @_fetch(room, pattern)
      pattern.replace(value)

  _store: (room, pattern) ->
    @cache[room] ||= []
    @cache[room].splice(0, 0, pattern)

    @robot.brain.data.auto_links = @_serialize()

  _fetch: (key, pattern) ->
    all = @cache[key]
    for p in all
      return p if p.matches(pattern)

  _serialize: ->
    serialized = {}
    for room, patterns of @cache
      serialized[room] = patterns.map (p) -> p.toHash()
    serialized

class Pattern
  @fromHash: (hash) ->
    new this(hash.url, hash.pattern)

  constructor: (@url, @pattern) ->

  replace: (value) ->
    @url.replace(@pattern, value)

  matches: (pattern) ->
    pattern is @pattern

  toHash: ->
    { url: @url, pattern: @pattern }

module.exports = (robot) ->
  linker = new Autolinker(robot)
  patterns = {
    issues:  ":number"
    commits: ":sha"
  }

  room = (msg) ->
    msg.message.user.room

  robot.respond /autolink (.+) to (.+)/, (msg) ->
    if patterns[msg.match[1]]
      pattern = new Pattern(msg.match[2], patterns[msg.match[1]])
      linker.remember(room(msg), pattern)
      msg.send "Ok, from now autolinking #{msg.match[1]} to #{pattern.url}"
    else
      msg.send "I don't know how to autolink '#{msg.match[1]}'"

  robot.hear /(https?:\/\/)?\S*\#(\d+)/, (msg) ->
    if !msg.match[1] # if it's not already a link
      if link = linker.link(room(msg), patterns.issues, msg.match[2])
        msg.send "Issue ##{msg.match[2]}: #{link}"

  robot.hear /(https?:\/\/)?\S*\b([0-9a-f]{6,41})\b/, (msg) ->
    if !msg.match[1] # if it's not already a link
      if link = linker.link(room(msg), patterns.commits, msg.match[2])
        msg.send "Commit #{msg.match[2]}: #{link}"
