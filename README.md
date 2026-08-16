## Fitness planner and tracker. 

This is intended for use with Claude AI and TrainingPeaks.

This works with a single skill invocation /tp-cycling-coach which will provide
a weekly plan based on the numbers that it pulls from TrainingPeaks on your
current activities and performance level.

The skill will directly populate TrainingPeaks with structured workouts.

Aside from that main skill invocation you can also chat with Claude and take
advantage of full access to TrainingPeaks as part of the conversation, whether
just to find out about your current data, or to tweak your workouts directly.

### Setup
A prerequisite is having access to Claude Code. All planning is done from within
the Claude Code terminal.

Having cloned this repo, do the following:
```
make init
```
This will clone the TrainingPeaks MCP server submodule, and set up Claude settings
so it all works. Once that's done, fire up a browser and log in to your TrainingPeaks
account. This browser session will be used to acquire a cookie from. To do that
return to your terminal session and:
```
make cookie
```
If that was successful your local .env file should contain a sane value assigned
to the TP_AUTH_COOKIE setting.

Next, exit Claude Code, if you had a session going, and in the repo root fire it
up again. Then ask it if it can access TrainingPeaks.

Assuming it can, you can create a week's training plan using the following:
```
/tp-cycling-coach
```
