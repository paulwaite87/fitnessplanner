---
name: tp-cycling-coach
description: Plan a cyclist's training week as a standalone coaching package with integrated workout building. 
  Use whenever the athlete asks to plan a week or the upcoming week ("plan my week", "build my training week", 
  "week schema", "plan a week workout schedule", or any localized equivalent), or states a goal for the week. 
  The flow reads a per-athlete config, pulls recent TrainingPeaks data, classifies rider type from the athlete's 
  own power curve, then produces one weekly plan and structured bike workouts uploaded to TrainingPeaks per 
  structured bike session without relying on another skill. Works for any cyclist.
metadata:
  author: Elio Struyf <elio@struyfconsulting.be>, Paul Waite <paulwaite87@gmail.com>
  license: MIT
  version: 3.0.0
---

# Cycling coach
Turn a short conversation into the structured bike workouts it references. Workouts are uploaded directly to 
TrainingPeaks, in structured workout format which can be directly used with TPVirtual, or downloaded to a 
cycle computer for use out on the road.

## Resolve config first (every run)
Before doing any real work:
1. Look for the config at `athlete.json` (next to this skill).
2. If it exists and parses, load it and go straight to the main workflow.
3. If it is missing or invalid (first run), run the setup flow in `references/onboarding.md`, 
write `athlete.json`, then continue into the main workflow in the same turn. Do not make the athlete re-invoke the skill after setup.

The `athlete.json` file is the single source of truth for who the plan is for. Fields are documented in 
`references/athlete-config.md`.

From the config take: `name` (greetings), `language` and `units` (everything the athlete reads is 
produced in these), `styleNotes` (writing rules to honor), `goal`, `age`, `gender`, `weightKg`,
`fallbackFtp`, `targetWkg`, `groupRideDays`, `typicalAvailableDays`, `typicalWorkoutDurationMin`, 
`maxStructuredSessions`, `strengthDefault`, and optional `riderTypeOverride`.

If `age` is missing from an existing config, ask for it before continuing — it is required to set 
recovery windows. If `gender` is missing, ask for it or accept a skip; note that it defaults to 
gender-neutral W/kg benchmarks when absent.

At the start of every weekly planning run, ask a short weekly-availability intake before training design:

- Available training days for the upcoming week.
- Planned group-ride day(s) for the upcoming week.
- Planned duration per workout day.
- Strength preference this week: strength, core, or both.
- Frequency for strength/core this week (how many times).

Always offer a one-step option to use predefined values from `athlete.json` profile config (for example:
typical training days, `groupRideDays`, `strengthDefault`, and any stored duration preferences). If 
the athlete chooses profile defaults, confirm what was applied and only ask for overrides.

## Main workflow

### Step 1 - pull data (TrainingPeaks)
Retrieve the athlete's current numbers and recent history.

**TrainingPeaks:** Test the connection. If not connected attempt diagnosis and report. It could just
require a refreshed login cookie. Allow the user to remedy that before continuing.
Tool calls and mapping are in `references/TrainingPeaks-access.md`. Get: current FTP and zones; gender from the 
athlete profile (populate `athlete.json` only if the field is currently absent — never overwrite a stated 
preference); the last 10 to 14 days of activities; and the power-duration curve from the most recent hard 
ride. TrainingPeaks activity names are preferred for archetype extraction.

Summarise last week and the readiness state back to the athlete in their language in one or two sentences.
If readiness data triggers a plan adjustment, state it explicitly.

### Step 2 - classify rider type (data-driven)
Unless `riderTypeOverride` is set, classify the athlete from their own power curve using `references/rider-types.md`.
The classification (sprinter/puncheur, all-rounder, diesel/time-triallist) plus the athlete's `goal` set the 
session priorities, which sessions to emphasise and which to skip. Do not assume a fixed rider type; derive it. 
State the detected type and the resulting focus in one line.

### Step 3 - confirm intake and session design
Restate the goal from the config in one line, then confirm or complete intake values gathered at the start. 
Ensure these are explicitly captured: available training days, group-ride day(s), duration per workout day, how 
many structured key sessions (default `maxStructuredSessions`), indoor or outdoor preference, week's focus, 
strength mode (strength/core/both), and strength/core frequency. Keep the intake short with the interactive picker 
when available. Always provide a "use profile defaults" path so the athlete can accept predefined config values 
and only override what changed. Factor last week's load into the new week.

### Step 4 - apply the training model
Use the FTP from TrainingPeaks (fallback: `fallbackFtp`), the rider type from Step 2, and the goal. Convert 
every % FTP target to watts in the human-readable text using that FTP. Principles and session shapes are in 
`references/training-model.md`. Always: polarized week, at most `maxStructuredSessions` structured days midweek,
group-ride days social with no forced structure, never three hard days back to back, steer by power and allow 
backing off on feel.

### Step 5 - build structured workouts
Build the workouts, and post each to TrainingPeaks directly using `references/TrainingPeaks-access.md`.

For reference:
- Session archetypes, rotation rules, and progression steps live in `references/workout-library.md`.
- Power is always defined as %FTP.
- Before selecting sessions, check the archetypes extracted from last week's TrainingPeaks rides (Step 1). Do not repeat the same archetype unless advancing it by one progression step. Use the rotation table in `references/workout-library.md` to pick this week's pair.
- Keep hard sessions capped by `maxStructuredSessions` and aligned with the polarized model.

### Step 6 - Summarize
Display a weekly plan summary which includes all required sections (week id, goal, focus, FTP used, rider type, 
last-week summary, day-by-day schedule table, structured session detail blocks). Offer to save the summary
as a .md file, named by 'Plan-' plus the ISO date-string of the week start.
