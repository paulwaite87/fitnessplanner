# athlete.json - the per-athlete config

This file is the single source of truth for who a plan is for. Each user owns their own copy. The skill reads it; it is never edited inside SKILL.md.

| Field                       | Type             | Meaning                                                                                                                                                                                                                    |
|-----------------------------|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`                      | string           | The athlete's name, used in greetings.                                                                                                                                                                                     |
| `language`                  | string           | Output language for everything the athlete reads (e.g. `en`, `nl`, `fr`, `de`, `es`, `it`). Machine keys stay English.                                                                                                     |
| `units`                     | string           | `metric` (km, km/h) or `imperial` (mi, mph). Power is always watts; strength uses W/kg regardless.                                                                                                                         |
| `goal`                      | string           | The athlete's main goal, in their own words. Keep it concrete. The skill plans toward this every week.                                                                                                                     |
| `goalDate`                  | date             | The athlete's main goal date. The skill plans toward this every week.                                                                                                                                                      |
| `goalDistanceKm`            | integer          | The athlete's main goal distance, The skill plans toward this every week.                                                                                                                                                  |
| `age`                       | integer          | Athlete's age in years. Used to tune recovery expectations (masters athletes 40+ need more recovery between hard sessions) and contextualise W/kg benchmarks. Not available from TrainingPeaks — always ask at onboarding. |
| `gender`                    | string           | `male`, `female`, or `other`. Pulled from TrainingPeaks athlete profile when available; ask at onboarding if TrainingPeaks is unreachable. Used to contextualise W/kg benchmarks and training load norms.                  |
| `weightKg`                  | number           | Body weight in kg (used for W/kg). Imperial users still store kg; convert at onboarding.                                                                                                                                   |
| `fallbackFtp`               | integer          | FTP in watts to use when TrainingPeaks is unreachable. Live FTP from TrainingPeaks overrides it.                                                                                                                           |
| `targetWkg`                 | number           | Target W/kg for context and progress.                                                                                                                                                                                      |
| `groupRideDays`             | string[]         | Days that are social group rides by default, e.g. `["Sat","Sun"]`. No structure is forced on these.                                                                                                                        |
| `typicalAvailableDays`      | string[]         | Days the athlete usually can train. The weekly intake can narrow this.                                                                                                                                                     |
| `typicalWorkoutDurationMin` | number           | Default workout duration in minutes (e.g. `60`). The weekly intake can override this per day.                                                                                                                              |
| `maxStructuredSessions`     | integer          | Cap on structured key sessions per week (usually 2).                                                                                                                                                                       |
| `strengthDefault`           | string           | `strength+core`, `core`, or `none`.                                                                                                                                                                                        |
| `riderTypeOverride`         | string or null   | Force a rider type (`sprinter`, `allrounder`, `diesel`) instead of deriving it. Null means derive from the power curve.                                                                                                    |
|-----------------------------| ---------------- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|


## How age and gender influence the plan
- **Age < 40:** standard recovery windows apply (hard day, one easy day, repeat).
- **Age 40–49 (masters):** add an extra easy day between hard sessions when possible; cap weekly TSS slightly lower.
- **Age 50+ (senior masters):** two easy or rest days between hard sessions is the default; volume comes second to quality.
- **Gender:** use gender-appropriate W/kg benchmarks when contextualising progress (e.g. 3.5 W/kg is a different relative level for male vs female athletes). Never adjust raw watt targets — those are FTP-derived and already personalised.

## How goal date and km influence the plan
- The goal date will set the taper week, and also the week maximum endurance kms rides are planned.
- The goal date sets the number of weeks remaining, and will influence distances called for on endurance rides in the latter half of the schedule.
- If distance is above 80km then planning during the last half of the duration (see goal date) will aim to achieve endurance rides peaking at 80% of goal kms by the taper week.

Days use the three-letter English keys `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun` so the app can read them in any language.
