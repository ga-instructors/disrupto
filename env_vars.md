## Environment Variables Needed for Hubot

**For the Hubot to work, it will require each of the below variables set on Heroku**

- Use the `heroku config:set` command to assign each of these.
- NOTE: You will see a REDISCLOUD variable needed below. The Heroku docs tell you to use RedisToGo, however the RedisCloud free tier gives you more free space and hooks up directly to the Hubot with no extra configuring.

| Environment Variable            |  Example (if applicable)   |
|:-------------------------------:|:--------------------------:|
| COURSE_REPO                     | ga-students/Knope |
| GITHUB_USER_NAME                | darthneel |
| HEROKU_URL                      | Heroku URL hosting the bot |
| HUBOT_GITHUB_TOKEN              | I use my personal github token |
| HUBOT_INSTRUCTOR_ROOM           | Slack ID for your instructor's chat room |
| HUBOT_STUDENT_ROOM              | Slack ID for your student's chat room |
| HUBOT_SLACK_TEAM                | ga-students |
| HUBOT_SLACK_TOKEN               | Slack API Token assigned to your instance of the bot |
| INSTRUCTOR_GIST_URL             | URL to a Gist that has a JSON of your Instructors info* |
| STUDENT_GIST_URL                | URL to a Gist that has a JSON array of your Students info** |
| REDISCLOUD_URL                  | Use Heroku addons to give your Hubot a RedisCloud instance |
| HUBOT_HEROKU_KEEPALIVE_URL      | See https://github.com/hubot-scripts/hubot-heroku-keepalive |
| HUBOT_HEROKU_KEEPALIVE_INTERVAL | "" |

---

 *  - Key: Name, Value: github username - {"Neel":"darthneel", "Andy":"andrewfritz86"}
 ** - Each value in the array is a hash of student info. Keys - id, fname, lname, email, github. [{"fname":"Neel", "lname":"Patel", "email":"blah@gmail.com", "github":"darthneel"},{"fname":"Andy", "lname":"Fritz", "email":"blah2@gmail.com", "github":"andrewfritz86"}]

 ---

 ```json
 [
  "hubot-diagnostics",      // ping, adapter, echo, time
  "hubot-help",             // help, help <query>
  "hubot-heroku-keepalive", // (see https://github.com/hubot-scripts/hubot-heroku-keepalive)
  "hubot-redis-brain"
  // "hubot-google-translate",
  // "hubot-google-images",
  // "hubot-maps",
  // "hubot-rules",
  // "hubot-shipit",
  // "hubot-youtube"
]

[
  "hubot-redis-brain",      // (see https://github.com/hubot-scripts/hubot-redis-brain)
  "hubot-heroku-keepalive", // (see https://github.com/hubot-scripts/hubot-heroku-keepalive)
  "hubot-diagnostics",      // ping, adapter, echo, time
  "hubot-cron",             // new job, list jobs, rm job,  tz job
  "hubot-help"              // help, help <query>
]
```