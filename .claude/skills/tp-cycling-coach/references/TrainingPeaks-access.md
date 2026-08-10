# TrainingPeaks access and snapshot output
Pull the athlete's recent data before building, so the plan is grounded in what they did and their current numbers. TrainingPeaks is the source for all the data, so if the site is unreachable, then say so, together with any diagnostics to help with re-establishing connectivity.


## Data Required
1. Current FTP, Power Zones and Heartrate Zones. This is the FTP used for the week plan.
2. Athlete name, weight, measurement preference, and **gender**. Populate the `gender` field in `athlete.json` from this value **only if the field is currently absent**. Age is **not** returned
by TrainingPeaks — it must come from `athlete.json`.
3. Completed activities ~14 days back - recent rides.
4. Activity performance on the most recent hard ride to ascertain best efforts. Use this ride
to calculate the power curve (5s, 1min, 5min, 20min Power). This is used for rider-type classification.

## Summarise last week
From the last 7 days: rides, total distance, hours, elevation, and how many hard days. Summarise in one sentence, and use it to tune the new week's load.

## Extract last week's session archetypes
For each ride in the last 7 days with high relative effort (structured ride), extract the activity name. Map it to the closest archetype from the workout library using the name as a hint:

| Name contains… | Archetype |
|----------------|-----------|
| "sweet spot", "sweetspot", "ss" | `sweet-spot` |
| "over-under", "over under", "ou" | `over-unders` |
| "vo2", "vo2max", "4x4", "5x4", "intervals" | `vo2max` |
| "40/20", "4020", "30/30", "3030" | `40-20s` |
| "threshold", "ftp" | `threshold` |
| "endurance", "z2", "easy" | `endurance` |

If the name does not match any pattern, mark the archetype as `unknown`. Pass the list of last week's archetypes to Step 5 so session selection can avoid repeats and pick the right progression step.

## TrainingPeaks MCP Server
The data can be accessed (for read and write) using the TrainingPeaks MCP server. Here are the tools to use with that:

### Workouts
| Tool | Description |
|------|-------------|
| `tp_get_workouts` | List workouts in a date range (max 90 days) |
| `tp_get_workout` | Get full details for a single workout |
| `tp_create_workout` | Create a workout with optional interval structure, auto-computed IF/TSS, and optional planned start time |
| `tp_update_workout` | Update any field of an existing workout, including structured intervals and planned start time |
| `tp_delete_workout` | Delete a workout |
| `tp_copy_workout` | Copy a workout to a new date (preserves structure and planned fields) |
| `tp_reorder_workouts` | Reorder workouts on a given day |
| `tp_pair_workout` | Pair a completed workout with a planned workout (merges into one) |
| `tp_unpair_workout` | Unpair a workout (splits into separate completed and planned workouts) |
| `tp_validate_structure` | Validate interval structure without creating a workout |
| `tp_get_workout_comments` | Get comments on a workout |
| `tp_add_workout_comment` | Add a comment to a workout |
| `tp_get_workout_note` | Get the private workout note for a workout |
| `tp_set_workout_note` | Set or update the private workout note |
| `tp_upload_workout_file` | Upload a FIT/TCX/GPX file to a workout |
| `tp_download_workout_file` | Download a workout's device file |
| `tp_delete_workout_file` | Delete an attached file from a workout |

### Analysis & Performance
| Tool | Description |
|------|-------------|
| `tp_analyze_workout` | Detailed analysis with time-series data, zones, and laps |
| `tp_get_peaks` | Power PRs (5s-90min) and running PRs (400m-marathon) |
| `tp_get_workout_prs` | PRs set during a specific session |
| `tp_get_fitness` | CTL, ATL, and TSB trend (fitness, fatigue, form) |
| `tp_get_weekly_summary` | Combined workouts + fitness for a week with totals |
| `tp_get_atp` | Annual Training Plan - weekly TSS targets, periods, races |

### Athlete Settings
| Tool | Description |
|------|-------------|
| `tp_get_athlete_settings` | Get FTP, thresholds, zones, profile |
| `tp_update_ftp` | Update FTP for a sport's power set (bike default; preserves the set's calculation method) |
| `tp_update_hr_zones` | Update HR threshold/max/resting for a sport (general/bike/run/swim), preserving the method |
| `tp_update_speed_zones` | Update run/swim threshold pace, preserving the method |
| `tp_create_zones` | Create a NEW per-sport zone set from scratch (choose the calculation method); errors if one already exists |
| `tp_get_zone_methods` | List available zone-calculation methods per metric (power/HR/pace) with each method's zone count and labels |
| `tp_update_nutrition` | Update daily planned calories |
| `tp_get_pool_length_settings` | Get pool length options |

**Zone updates — how they work & one limitation.** The zone setters target the
right per-sport zone set (by `workoutTypeId`) and recompute the bands with
**TrainingPeaks' own zone calculator** (the same call the web UI's *Calculate*
makes), so the athlete's calculation method (%LTHR, Karvonen, Andy Coggan, …) is
honoured exactly. They update a **threshold** (FTP / LTHR / threshold pace).

> **Limitation — test-based (Distance/Time) methods.** A zone set whose method
> *derives* its threshold from a test result (Speed/Pace **Distance / Time**)
> cannot have a threshold set directly — there is no stable value to set. These
> tools detect that case and return `TEST_BASED_METHOD` (writing nothing) rather
> than storing a wrong threshold; configure such a set via a test in the
> TrainingPeaks UI. This is deliberate: the connector owns threshold-anchored
> zones; test-protocol setup stays in the UI.

### Health Metrics
| Tool | Description |
|------|-------------|
| `tp_log_metrics` | Log weight, HRV, sleep, steps, SpO2, pulse, RMR, injury |
| `tp_get_metrics` | Get health metrics for a date range |
| `tp_get_nutrition` | Get nutrition data for a date range |

### Equipment
| Tool | Description |
|------|-------------|
| `tp_get_equipment` | List bikes and shoes with distances |
| `tp_create_equipment` | Add a bike or shoe |
| `tp_update_equipment` | Update equipment details, retire |
| `tp_delete_equipment` | Delete equipment |

### Events & Calendar
| Tool | Description |
|------|-------------|
| `tp_get_focus_event` | Get A-priority focus event with goals |
| `tp_get_next_event` | Get nearest future event |
| `tp_get_events` | List events in a date range |
| `tp_create_event` | Add a race/event with priority (A/B/C) and CTL target |
| `tp_update_event` | Update event details, attach workouts as legs (multisport) |
| `tp_delete_event` | Delete an event |
| `tp_create_note` | Create a calendar note |
| `tp_list_notes` | List calendar notes for a date range |
| `tp_get_note` | Get a calendar note by ID |
| `tp_update_note` | Update title, description, date or visibility of a note |
| `tp_delete_note` | Delete a calendar note |
| `tp_get_note_comments` | List all comments on a note |
| `tp_add_note_comment` | Add a comment to a note |
| `tp_get_availability` | List unavailable/limited periods |
| `tp_create_availability` | Mark dates as unavailable or limited |
| `tp_delete_availability` | Remove availability entry |

### Workout Library
| Tool | Description |
|------|-------------|
| `tp_get_libraries` | List workout library folders |
| `tp_get_library_items` | List templates in a library |
| `tp_get_library_item` | Get full template details including structure |
| `tp_create_library` | Create a library folder |
| `tp_delete_library` | Delete a library folder |
| `tp_create_library_item` | Save a workout template |
| `tp_update_library_item` | Edit a template |
| `tp_schedule_library_workout` | Schedule a template to a calendar date, for one athlete or (coach accounts) several at once via `athletes` |

### Strength Workouts
| Tool | Description |
|------|-------------|
| `tp_search_exercises` | Search the built-in strength exercise library by name (offline) |
| `tp_create_strength_workout` | Create a structured strength/gym workout (blocks of exercises with sets and parameters) |
| `tp_get_strength_summary` | Get a strength workout's compliance summary (blocks/prescriptions/sets completed) |
| `tp_get_strength_workouts` | List strength/gym workouts in a date range (they don't appear in `tp_get_workouts`) |
| `tp_get_strength_workout` | Get a strength workout's full detail: blocks, exercises, sets, prescribed vs executed weights |
| `tp_update_strength_workout` | Update a strength workout in place (replace/append blocks, retitle, mark complete) - preserves Garmin TSS and FIT files, so use this rather than delete-and-recreate on device-synced workouts |
| `tp_delete_strength_workout` | Delete a strength workout by ID |

### Athlete Groups (coach accounts)
| Tool | Description |
|------|-------------|
| `tp_list_groups` | List the coach's athlete groups (TP tags) |
| `tp_list_athletes_in_group` | List the athletes in one group, with names resolved from the roster |
| `tp_create_group` | Create a new athlete group |
| `tp_rename_group` | Rename an athlete group (default group cannot be renamed) |
| `tp_delete_group` | Delete a group - the grouping only, athletes are not deleted |
| `tp_add_athletes_to_group` | Add one or more athletes to a group |
| `tp_remove_athletes_from_group` | Remove one or more athletes from a group |

### Training Plans (multi-week)
| Tool | Description |
|------|-------------|
| `tp_list_training_plans` | List the coach's authored multi-week training plans |
| `tp_get_training_plan` | Summary of one plan: weeks, per-week duration/distance, sport breakdown |
| `tp_get_training_plan_workouts` | All workouts of a plan laid out by week/day |
| `tp_apply_training_plan` | Apply a plan to an athlete's calendar from a start date (safe synthetic copy) |

### Reference & Auth
| Tool | Description |
|------|-------------|
| `tp_get_workout_types` | List all sport types and subtypes with IDs |
| `tp_get_profile` | Get athlete profile |
| `tp_auth_status` | Check authentication status |
| `tp_list_athletes` | List athletes (coach accounts) |
| `tp_refresh_auth` | Re-authenticate from browser cookie |

