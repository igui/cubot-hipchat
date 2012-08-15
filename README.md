Cubot-HipChat
=============

Modified HipChat adapter for GitHub's Hubot, based on
https://github.com/hipchat/hubot-hipchat

## Requirements

* [CoffeeScript](https://github.com/jashkenas/coffee-script) >= 1.3.3
* [npm](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) >= 1.1.48

## Configuration

The cubot hipchat expects some enviroment variables specifing the HipChat Jabber
user, nick and password for the robot user. The following steps

1. First you must [create](https://www.hipchat.com/sign_up) an account for the
   robot user in Hipchat
2. Set up enviroment variables for Cubot credentials

    ```shell
    export HUBOT_HIPCHAT_JID=XXXX_XXXX@chat.hipchat.com
    export HUBOT_HIPCHAT_NAME=cubot
    export HUBOT_HIPCHAT_PASSWORD=secret
    ```

   You can obtain these values in the HipChat Jabber account info page
   https://cubox.hipchat.com/account/xmpp

3. (Optional) If you want to persist data set up a
   [Redis To Go](https://redistogo.com/) or another and set the enviroment
   variable indicating the Redis DB URL

    ```shell
    export REDISTOGO_URL=redis://cubot-db:84834823330@tetra.redistogo.com:5555/
    ```

4. You are ready to go. Run the start script in the main dir

    ```shell
    ./start
    ```

## Deploying into Heroku

Cubot-HipChat is designed to be deployed into Heroku as a
[node.js app](https://devcenter.heroku.com/articles/nodejs). Provided you have
installed (Heroku Toolbelt)[https://toolbelt.heroku.com/] and configured it
properly you can deploy the app running the following commands

```shell
heroku create --stack cedar
heroku config:set HUBOT_HIPCHAT_JID=XXXX_XXXX@chat.hipchat.com
heroku config:set HUBOT_HIPCHAT_NAME=cubot
heroku config:set HUBOT_HIPCHAT_PASSWORD=secret

# (Optional)
heroku config:set REDISTOGO_URL=redis://cubot-db:84830@tetra.redistogo.com:5555/

git push remote heroku
```