# Description:
#   Sets up hooks to persist the brain into a Mongo DB
#
# Dependencies:
#   "mongodb": "1.1.x"
#
# Configuration:
#   MONGODB_URL as an enviroment variable
#   Example: mongodb://user:pass@host.com:4432/dbname
#
#
# Commands:
#   None
#
# Author:
#   igui

Url   = require "url"
mongo = require 'mongodb'

DEFAULT_MONGODB_URL = 'mongodb://localhost:27017'


module.exports = (robot) ->
  url = process.env.MONGODB_URL || DEFAULT_MONGODB_URL
  db = null
  mongo.connect url, (err, client) ->
    if err
      throw err
    db = client

    robot.logger.debug "Successfully connected to MongoDB"
    db.collection 'cubot_brain_data', (err, collection) ->
      if err
        console.log "Unable to access database: #{err}"
      collection.findOne (err, doc) ->
        if err
          console.log "Unable to get robot brain data: #{err}"
        robot.brain.mergeData doc

  robot.brain.on 'save', (data) ->
    robot.logger.debug "Saving Data..."
    if db is null
      return
    db.collection 'cubot_brain_data', (err, collection) ->
      if err
        console.log "Unable to access database: #{err}"
      collection.save data, (err, docs) ->
        if err
          console.log "Unable to save robot brain data: #{err}"

  robot.brain.on 'close', ->
    if db != null
      db.close()
