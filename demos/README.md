# Demos

Proof that the systems run, captured without recording anything.

Each demo is a VHS tape: a script of commands that renders itself to a GIF
with no human at the keyboard. Re-run the tape and the GIF regenerates
against the current state of the machine. A video goes stale the day the
system changes; these do not.

The narration that used to belong in a voiceover lives in each demo's
README instead, as prose between real command output. That is the format
most engineers read anyway, and it is indexable by search.

## The two

| # | Demo | Format | Why it earns its slot |
|---|---|---|---|
| 1 | [Platform health](02-platform-health/) | Tape, renders to GIF | Shows the scale and the drill interface, including real failures. |
| 2 | [Voice to vault](03-voice-to-vault/) | Written walkthrough | The trigger is a physical button press, so there is nothing honest to capture headlessly. Architecture and code instead. |

## Rendering

```bash
cd demos/02-platform-health && vhs demo.tape
```

Output lands next to the tape as `demo.gif`. GIFs are committed so the
site and the READMEs can embed them without a build step.

## Rules for every capture

**Read the "Do not show" section in each demo before rendering.** These
tapes run against a live machine that holds health data, real contacts,
and client material. The tapes are written to stay inside safe
directories, but output is generated at render time and is not fixed in
advance. A cron item that names a client can appear in the platform
health demo tomorrow even though it did not today.

**Review the rendered GIF frame by frame before committing it.** The
review is the same one the old recording checklist demanded, just moved
after the render instead of after the take:

- No real names, email addresses, or phone numbers
- No API keys, tokens, or `.env` contents
- No health values, sleep data, or coaching journal text
- No client or meeting material
- No file paths that expose a contact's name

If something private lands in a render, delete the GIF, do not just
re-render. The frame exists in the file until it does not.

**Never commit a curated run.** The platform health demo shows real
failures on purpose. A monitoring demo where everything is green is a
demo of nothing.
