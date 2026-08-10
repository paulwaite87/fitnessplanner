# Onboarding - first run

Run this when `athlete.json` is missing or incomplete. Keep it short, use the interactive picker when available, and write the config at the end. Ask in the athlete's language once it is known (start in English, switch as soon as they pick a language). After writing `athlete.json`, continue directly into weekly planning in the same turn.

## Questions

1. Language for your plans? (e.g. English, Nederlands, Francais, Deutsch, Espanol, Italiano)
2. Units? (metric km/h, or imperial mph)
3. What is your main goal this season? (free text, keep it concrete: a group pace, an event, a climb, a time)
4. If a main goal was given, ask what date we are working towards. This will tune the plan.
5. If a main goal was given, ask what distance the event is in km. 
6. How old are you? (age in years — used to set recovery expectations)
7. Gender? (male / female / other — used to contextualise W/kg benchmarks; skip if preferred)
8. Body weight? (kg)
9. Do you know your FTP? (a number in watts, or "no" to estimate it later from TrainingPeaks)
10. Target W/kg, if you have one? (optional; default 3.5)
11. Which days are your group or social rides? (default: Saturday and Sunday)
12. Which days can you usually train? (default: all)
13. Typical session duration? (minutes per workout, e.g. 60 or 90; the weekly intake can vary this per day)
14. How many structured key sessions per week? (1, 2, or 3; default 2)
15. Strength workouts by default? (strength + core / core only / none)

> **Gender note:** If TrainingPeaks is reachable it will be pulled automatically from the athlete profile. Still ask at onboarding so the config is complete before the first TrainingPeaks access, and to allow the athlete to correct it.

## Write the config

Map the answers onto the fields in `athlete-config.md` and write `athlete.json`. Set `riderTypeOverride` to null so the skill derives the rider type from data. Confirm in one line and continue to the weekly plan.

If FTP is unknown, set `fallbackFtp` to a conservative estimate (e.g. 2.5 W/kg times weight) and tell the athlete the first TrainingPeaks access or an FTP test will replace it.
