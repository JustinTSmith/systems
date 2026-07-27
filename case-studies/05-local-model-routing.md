# Cheap Models, Expensive Mistakes

Every team running agents eventually asks the same question: how much of
this can we do on a cheaper model? It is usually asked as a cost
question, answered with a vibe, and settled by whoever feels strongest
about it.

I had a specific version of the problem. My agents run all day, every
day, unattended. A morning briefing, a relationship pipeline, research
sweeps. None of that is hard reasoning, and paying frontier prices for it
felt like renting a surgeon to open mail. So I set out to move the
always-on layer onto local models running on my own machine.

The interesting part is not that it partly worked. It is where exactly it
stopped working, and how I found the line.

## First question: which local server

Before comparing models, I had to compare the things that serve them. Two
candidates, same model (Qwen3-8B at 4-bit), same prompt, measured
head to head.

MLX won on paper. Roughly 48 tokens per second of decode against Ollama's
32, about 1.5x faster, Metal-native, and it gets new models first.

I chose Ollama anyway, because throughput was the wrong thing to
optimize. The MLX server is single-threaded, so concurrent requests hang
rather than queue. Under load it dropped roughly one connection in four
and threw transient errors. Ollama was slower per token and produced zero
errors across more than eighty calls, with real request queuing and clean
model swapping.

A 1.5x speed advantage you cannot safely parallelize is not an
advantage. For a fleet of agents firing on schedules, concurrency and
error rate dominate tokens per second. MLX kept a job: the voice layer,
where one request at a time is the actual usage pattern, and where its
speed and model availability genuinely help.

That decision took an afternoon of measurement and saved me from an
architecture that would have failed intermittently and confusingly, which
is the worst way for anything to fail.

## Second question: can a local model do the work

This is where I stopped guessing and built a harness.

I took my real morning-briefing playbook, froze a single day of inputs so
every run saw identical data, and scored the output on four axes:
completeness, grounding (did it invent anything), whether it respected
protected-contact rules, and whether it honored its guardrails. Twenty
trials per model. Same prompt, same tools, same day.

**Qwen3-8B passed all axes on 13 of 20 runs, about 65%.**

The failure mode was not what I expected. It did not hallucinate: zero
fabrications across every non-empty brief, and guardrails held 40 out of
40. What it did instead was *nothing*. Roughly one run in five, it would
think, produce no brief, and exit successfully. A silent no-op that looks
identical to a quiet morning.

That is a far more dangerous failure than a wrong answer. A wrong brief
gets noticed. An absent brief gets mistaken for "nothing happened today."

I also tested a larger local model, GLM-4.7-Flash. It wrote noticeably
better briefs with a stronger look-ahead. It also auto-drafted a message
to a protected contact, which is a hard-rule violation the smaller model
never committed. Better mechanics, worse judgment. That pairing is worth
sitting with: fluency and obedience are not the same axis, and the model
that writes better prose is not automatically the one you can leave
unsupervised.

## The prediction I got wrong

Going in, I was confident that the tool surface was the problem. Thirty
four tools is a lot of choice for an 8B model, and narrowing it to six
seemed obviously helpful.

It made no measurable difference. The hypothesis was not confirmed.

On inspection my test was weak: the decoy tools were too dissimilar, so
choosing correctly never required fine discrimination. The honest state
is that the question is still open and my experiment could not answer
it. I am recording the failed prediction because a results table with no
disconfirmed hypotheses in it is usually a table that was not really
testing anything.

One more tempting knob turned out to be a trap. Disabling the model's
thinking step made it four to eight times faster. It also removed the
reasoning that the judgment depended on. Speed, purchased with exactly
the faculty I was trying to evaluate.

## Where the line landed

Local models handle the mechanical eighty percent: gathering, formatting,
transcription, classification, embeddings. That work is deterministic
enough to verify cheaply and voluminous enough that its cost is real.

Judgment escalates. Deciding what matters, what to prioritize, what to
draft to a human: that runs on a frontier model, or it runs locally and
gets verified by one before anything is sent.

The most valuable pipelines split a single job across the line rather
than choosing a side. My weekly briefing reads the entire newsletter
corpus on a local 35B model and passes only the distilled analysis to
Claude Opus for the writing. The expensive model never sees the raw pile.
Cost lives in the volume; quality lives in the last step; the split puts
each where it belongs.

And the empty-brief problem got the boring fix it deserved: a
retry-on-empty wrapper, cheap and local, which removes the dominant
failure mode without touching the model.

## What transfers

If you are making this decision for a product rather than a personal
setup, three things carried over cleanly:

1. **Measure the server, not just the model.** Concurrency behavior and
   error rate under load decided my architecture, and neither shows up
   in a tokens-per-second comparison.
2. **Score the failure modes separately.** A single quality number would
   have shown 65% and told me nothing. Splitting completeness from
   grounding from rule-following revealed that the model was honest and
   obedient but unreliable, which points at a retry wrapper rather than a
   better model. The remedy came from the shape of the failure.
3. **Route by stakes, not by cost.** "Use the cheap model where possible"
   produces the wrong answer, because the cheapest place to use it is
   often the highest-stakes step. Ask instead which steps you can verify
   cheaply, and put the cheap model there.

The real finding is unglamorous: local models are not a discount version
of frontier models, they are a different tool with a different failure
profile. Mine did not lie to me. It occasionally did nothing at all, and
knowing which of those two you are dealing with is the whole basis for
deciding what you can hand it.

The machine is mapped at [systems](https://github.com/JustinTSmith/systems).
