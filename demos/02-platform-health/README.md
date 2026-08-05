# The machine finds its own problems

![Job counts, then a nine-module health audit in six seconds](demo.gif)

Verified 2026-08-05. The numbers below are what the commands in the GIF
actually printed on that date, not a summary from memory.

## The number, and the problem it creates

```
$ launchctl list | grep -cE 'justinsmith|justinos|openclaw|paperclip|mnemo|gbrain'
41
$ crontab -l | grep -cvE '^[[:space:]]*(#|$)'
14
```

41 of my own LaunchAgents loaded, 14 crontab entries, plus 18 enabled
OpenClaw cron jobs. Agents, pipelines, databases, watchdogs.

Nobody is paged when one of them dies. The real failure mode for a system
this size is not a crash, it is silence: something stops, and I find out
three weeks later because a thing I assumed was happening was not.

## Nine modules, concurrent, six seconds

```
$ python3 -m platform_health.main --dry-run
```

Backups, configs, cron coverage, the gateway, git, logs, skills. Eleven
findings, 28 checks passing.

This is what it actually looks like, and I do not curate it before
rendering. Three crons that have run once. A gateway log untouched for
1610 hours. Two skills missing their `SKILL.md`. A SQLite backup that has
not been written in 51 days. The point of the system is not that
everything is green. It is that I am looking at a list instead of
assuming it is fine.

Every finding is numbered so it can be addressed by number, from Telegram
or from the shell. The design constraint is that a finding I cannot act
on in one step is a finding I will not act on. Every monitoring system I
have watched fail, failed by producing more signal than anyone would
triage.

## What is broken about it right now

Two things visible in that GIF, both mine, neither fixed yet:

**`--dry-run` only changes delivery, not behavior.** It prints to stdout
instead of Telegram, but the auto-fix path still executes. A flag named
`--dry-run` that repairs things is a trap I set for myself. It needs a
`--no-fix` flag, or the auto-fix needs to respect the one that exists.

**The auto-fixer reports success on failure.** The Auto-Fixed block shows
two green checkmarks over a commit that failed and a push that was
rejected. The fix function returns its output message rather than its
exit status, so any attempt counts as a repair. That is the same class of
bug as the fail-open scanner in [demo 1](../01-injection-defense/): the
error path was never the path anyone tested.

I left both in the capture. A monitoring demo that hides the monitor's
own bugs is advertising, not evidence.

## Do not show

The findings list is generated at render time and changes daily. Today it
is all infrastructure. Tomorrow a cron item could name a client or a
health file. Read every frame of a fresh render before committing it.

Source: `~/Workspace/scripts/platform_health/`
