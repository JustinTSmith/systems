# One press of a button

**No capture for this one, on purpose.** The trigger is a physical button
press on a phone, and the payload is my own voice saying something real.
Neither part can be captured headlessly without staging a fake, and a
staged capture of a capture pipeline is worth less than an honest
description of it. Architecture and code below.

## The problem

I have ideas away from my desk, and the friction of capturing one is the
reason most of them die. Open an app, pick a folder, name a note, type.
By then the idea is gone or I am somewhere else.

The rule behind this whole system: **capture has to be cheaper than
avoidance.** If logging a thought costs more effort than ignoring it, I
will ignore it, and no amount of discipline changes that.

So capture costs one button. Press the Action Button, talk, release. A
note appears in the right folder of my vault, transcribed and filed,
without me choosing anything.

## The path

```
Action Button
  -> iCloud voice memo
  -> obsidian_voice_processor.py  (running as a LaunchAgent, KeepAlive)
  -> local transcription
  -> local model classifies into one of 8 categories
  -> filed into the matching vault folder
  -> indexed and synced
```

The eight categories are fixed in `CATEGORY_FOLDERS`: note, todo,
journal, idea, learning, goal, question, relations. A note lands in
Inbox, a todo in Tasks, an idea in Ideas. I never pick the folder.

## Three details that are the actual engineering

**Three redundant triggers.** A file watcher, a KeepAlive LaunchAgent,
and a scheduled job all reach the same processor:
`com.justinsmith.obsidian-voice-processor-watcher` and
`com.justinsmith.obsidian-voice-processor` are separate registered
agents. If one dies I never notice, because the others are still running.
This is the same instinct as [demo 2](../02-platform-health/): the
failure mode I fear is silence, not crashes.

**A scratch directory outside iCloud.** iCloud will hand you a file that
is not finished downloading. Work happens in
`~/Workspace/scripts/.voice_scratch`, which survives crashes and copy
retries, and the vault only ever sees a complete file.

**A dead letter path.** After three failed transcription attempts a file
moves to `Failed/` instead of being retried forever. Counts persist to
disk in `failure_state.json`, because the process restarts and a retry
counter held in memory is a retry counter that resets to zero every time
it matters. Silent recordings and corrupt files were the real case: they
never succeed, and without a dead letter path they occupy the pipeline
permanently.

## The cost point

Transcription and classification both run on local models, so the
marginal cost of capturing a thought is zero. That matters more than it
sounds. Anything I pay per use for, I use less than I should, and a
capture system I hesitate to use is a capture system that does not work.

To be exact about it: the machine and the electricity are not free, and
judgment work still escalates to cloud models by explicit routing policy.
The claim is narrower than "free" - it is that the per-thought cost of
capture is not a number I have to think about.

## Do not show

If this is ever captured or screenshotted:

- Never open the vault's Health, Personal, Parenting, or Journal folders
- Never `cat` the processor source on screen. It contains my daughter's
  name in directory constants and sleep-log routing.
- Never show a real transcription. Every voice note is real content.

Source: `~/Workspace/scripts/obsidian_voice_processor.py`
