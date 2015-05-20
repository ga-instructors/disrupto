needs to be hubot but with:

- init process (__init)
- `bot.apis` as a hook for libs
  - cron
  - moment
  - time
  - lodash
- load process (_load) that allows ordered loading
- a connection for a "manager" express app that translates the brain and other
  things in to a simple cms (_manager)
- auth & roles (_auth)
- a new help processor that parses help differently based on role (_help)
- a testing framework wrapper that eases the test process (_test)
  - attaches to `bot.test`
    - bot.test.apis
    - listeners and regex shorthand
    - help
    - auth dependent issus
    - http routes (manager)