# The Machine

*One operator, sixty-nine unattended jobs, and roughly ninety agents on a
Mac Studio in Squamish. What I built, what it taught me, and what broke
along the way.*

---

In January 2025 I got back the results of a psychometric assessment. I
had spent two years as Director of Product at the company that makes it,
so I knew exactly what happens to those reports. People read them, feel
seen, and file them. Maybe they get pulled out again before a performance
review.

I fed mine to an AI instead.

What follows is what got built over the next fourteen months. It now runs
my work, my research, my health tracking, my relationships, and two
software ventures. Most of it runs while I sleep. This is a tour of the
architecture, but more usefully it is a record of what I learned, most of
which I learned by getting it wrong first.

---

## Chapter 1: What is actually running

There is a Mac Studio in my office that does not turn off. On it:
sixty-nine scheduled jobs, which breaks down as forty-three LaunchAgents,
fourteen cron entries, and twelve agent jobs. Roughly ninety agents
spread across thirteen agent companies. Two local model servers, a
Postgres instance, a Redis instance, a memory server, and a gateway.

At 7am my phone rings. Not a notification, an actual call. A script
reads the day's briefing out of my knowledge vault, rewrites it in the
voice of a coach, synthesizes it to audio, and Twilio dials me. I pick
up, get told what matters today, and it hangs up.

On Mondays at 1am, four research agents run in parallel across AI
infrastructure, sales signals, competitors, and client verticals. Their
findings become a written briefing. The briefing then becomes a
podcast-style audio overview, which I listen to while driving, because a
briefing I have to sit down and read competes with everything else I have
to sit down and read. A fifteen-minute audio file competes with nothing.

That last decision is the pattern for everything here. The systems are
not clever. They are shaped around the specific ways I fail.

---

## Chapter 2: The assessment became the spec

An assessment scores you across dozens of dimensions. Read them
separately and you get a flattering list of strengths and a homework list
of weaknesses. That framing is useless for building anything.

The value is in the pairs that fight each other.

I score 95 on Full Accountability and 13 on Establishing Order. Sit with
the shape of that. I feel personally responsible for everything, and I
have almost no native ability to sequence work. The responsibility never
finds structure on its own. A missed deadline lands as a personal failure
rather than a planning problem, and trying harder does not fix it,
because trying harder is the 95 doing exactly what it always does.

You cannot coach that away with a productivity book. But you can build
for it. So every agent in my system converts loose talk into structure
without being asked. I say something vague in my Telegram thread and what
comes back has an owner, a deadline, and a success metric. A `log:` prefix
creates a timestamped task and replies with nothing but an ID. Nothing I
say that implies work is allowed to stay ambient.

I score 80 on Focus on Others and 80 on Self-Sufficiency. The caring is
real and the reaching out never happens. Two strengths, one dead
friendship at a time. So a pipeline reads my sent mail and calendar,
scores every real relationship on recency, frequency trend, and
reciprocity, and tells me who is drifting. Birthday messages draft
themselves from actual conversation history. I still do the caring. The
system does the reaching.

I score 28 on Logic and Data against 71 on Thinking Conceptually. Ideas
arrive quickly and evaluation of them does not. Left alone I generate
fifty ideas, chase whichever one is most emotionally alive, and never
rank the other forty-nine. So ideas do not get my attention. They get a
queue. At 2am an agent works through everything logged that day: web
research, a structured pass on trade-offs and failure modes, synthesis
against my knowledge base. By morning each one is a paragraph with a
recommendation.

One sentence I logged that way was about psychiatrist billing in Canada.
It came back saying the pain was real, quantified, and structural. That
sentence is now a venture with a product requirements document, a
bottom-up revenue model, and an agent company building it.

The full version of this story is
[The Assessment That Became an Operating System](../case-studies/01-assessment-driven-agents.md).

---

## Chapter 3: The memory problem is the real problem

There is a moment everyone working with AI daily eventually hits. You
open a fresh session and yesterday's brilliant collaborator has never met
you. The decision you reached at 11pm, the approach you ruled out after
an hour of dead ends, the client detail that changes everything: gone.
You are paying frontier prices for a colleague with amnesia.

Multiply that across a fleet and they are not a team, they are a row of
strangers, each rediscovering my life from scratch and occasionally
contradicting each other before breakfast.

So four hooks wire memory into every session at the exact moments a
session leaks knowledge. Session start pulls prior context. Before any
web search, a hook forces a check against my own knowledge base first,
which is both a cost decision and a quiet statement about whose judgment
accumulates. After tool use, activity syncs back. At session end, an
audit runs.

Then overnight, a synthesis job reads what every agent did that day and
writes a brief. Each agent's next session starts with it. The coding
agent knows what the research agent ruled out. I stopped being the
message bus between my own tools.

I did not write the memory engines. Two open-source projects do that work
and I credit them plainly. What I built is the nervous system around
them, and that is where every hard problem lived. The full account,
including the search that returned confident wrong answers and the
knowledge graph that ran for weeks with zero edges, is in
[Every Agent Wakes Up Knowing What the Others Did](../case-studies/02-memory-spine.md).

---

## Chapter 4: Disagreement is the product

The single most useful thing I have learned building any of this is also
the easiest to steal.

Ask one agent to consider multiple perspectives and you get a bland
consensus, because it is one prior wearing costumes. Give several agents
genuinely incompatible priors, make them work the same evidence
independently, and then force a written synthesis that records dissent
instead of averaging it away, and something different happens. The
disagreement is the signal.

I run this pattern in four places.

**A medical council.** Twenty years of unexplained fatigue with no
diagnosis is a research problem wearing a medical costume. So there is a
company of specialist agents: an internist, a neurologist, an
immunologist, an endocrinologist, a psychiatrist, and a lead who runs the
case. They argue. The lead forces a written consensus with dissent
recorded. The output is a structured differential with mechanisms and a
ranked test list, written to hand to an actual physician. That framing is
the entire design. It produces better-prepared questions, not answers,
and every report says so.

**An equity research desk.** The busiest company in the fleet by an order
of magnitude. Analysts work the same securities from deliberately
incompatible philosophies, score conviction independently, and a
synthesis agent assembles a matrix showing where they agree and where
they split. A four-of-four agreement means something precisely because
the analysts were built to argue.

**A nightly security council.** Six static collectors gather evidence,
then four analysts read it from different angles: red team, blue team,
data privacy, and operational realism.

**And the goal process**, where a book-derived skill supervises my own
planning against a framework I did not write.

Of those four security perspectives, operational realism is the one I
would keep if I could only keep one. Red teams generate findings faster
than any human can act on them, and an unprioritized security report is a
document you stop opening by week three. Operational realism is what
turns a list into a queue.

---

## Chapter 5: Cheap models fail differently than you expect

Every team running agents eventually asks how much of this can run on a
cheaper model. It is usually asked as a cost question, answered with a
vibe, and settled by whoever feels strongest about it.

I had a specific version. My agents run all day, unattended. Briefings,
relationship scoring, research sweeps. None of it is hard reasoning, and
paying frontier prices felt like renting a surgeon to open mail.

So I built a harness instead of guessing. I took my real morning briefing
playbook, froze one day of inputs so every run saw identical data, and
scored the output on four axes across twenty trials.

The local 8B model passed all axes on 13 of 20 runs. About 65 percent.

The failure was not what I expected. It did not hallucinate: zero
fabrications across every non-empty brief, and guardrails held forty out
of forty. What it did instead was nothing. Roughly one run in five it
would think, produce no brief, and exit successfully.

That is a far more dangerous failure than a wrong answer. A wrong brief
gets noticed. An absent brief gets mistaken for a quiet morning.

I also tested a larger local model. It wrote noticeably better briefs.
It also auto-drafted a message to a protected contact, a hard rule
violation the smaller model never committed. Better mechanics, worse
judgment. Fluency and obedience are not the same axis, and the model that
writes better prose is not automatically the one you can leave alone.

Before any of that I had to choose how to serve these things. On paper
the MLX server won: roughly 48 tokens per second against Ollama's 32,
about 1.5 times faster. I picked the slower one. MLX is single-threaded
so concurrent requests hang rather than queue, it dropped about one
connection in four under load, and it threw transient errors. Ollama was
slower per token and made zero errors across more than eighty calls, with
real queuing. A speed advantage you cannot safely parallelize is not an
advantage.

Where the line landed: local handles the mechanical eighty percent.
Gathering, formatting, transcription, classification, embeddings.
Judgment escalates. And the best pipelines split a single job across the
line rather than picking a side. My weekly briefing analyzes the entire
newsletter corpus on a local 35B model and passes only the distilled
output to a frontier model for the writing. The expensive model never
reads the raw pile. Cost lives in the volume, quality lives in the last
step.

Full findings, including the hypothesis I got wrong, are in
[Cheap Models, Expensive Mistakes](../case-studies/05-local-model-routing.md).

---

## Chapter 6: I gave them the keys before I designed the locks

There is a moment where you take inventory of what you have handed out.
Mine went roughly: these agents can read my inbox, write to my files, run
shell commands, reach the network, and post as me in a channel I read
every day. Any of them can be reached by content I did not write, because
reading the internet is the job.

That is not a hypothetical attack surface. That is a production system
with my life in it, assembled one convenient integration at a time.

An audit found two things that set the design. Credentials had spread: a
single token had propagated into roughly ten places across config files,
environment files, scripts, and logs. And a service had failed silently
for days, because two processes were polling the same bot and knocking
each other offline in a loop. From outside it looked like the assistant
had simply gone quiet, which is indistinguishable from having nothing to
say.

Neither is exotic. Both are the ordinary way personal infrastructure
decays: secrets sprawl and failures go unobserved.

The posture that came out of it has six layers, but one decision matters
more than the rest. Prompt injection defense runs in two stages: cheap
regex first, then a language model verdict on anything that survives. The
important part is not that a model does the judging. It is which model,
in which context.

The scan runs as a separate call, in a fresh context, with the suspicious
content quoted as data. The agent that would have received the content
never sees it unless it passes.

Because the alternative is incoherent. If you ask an agent to evaluate
whether the message it just read was an attack, you have already given
the attack its opportunity. The content is in the context, and the same
instruction-following behavior you are testing is the behavior doing the
testing. An agent cannot be trusted to assess an attack aimed at itself,
any more than a compromised host can be trusted to report that it is
compromised.

The rest is tuning. That one separation is the idea.

The whole posture, and the fail-open bug I found in my own code while
writing it up, is in
[I Gave Agents My Email and Shell Access](../case-studies/04-agent-security.md).

---

## Chapter 7: What broke

Every system above has a version of this section, and the sections are
more useful than the architecture.

**A memory search that lied.** It returned confident results with nothing
to do with the query, and returned them instead of saying no match.
Verbatim terms that existed in three documents retrieved something
unrelated. In a memory system a wrong answer is worse than no answer,
because nobody double-checks their own memory.

**A knowledge graph with zero edges.** It ran for weeks with every page
an island, which defeats the point of a graph. The extractor was not
broken, it was strict. My pages used shorthand links and the resolver
wanted full paths. One configuration change later the same extractor
built 226 edges from the same pages. Before concluding a system is
broken, check whether it is merely pedantic. One gets fixed with config,
the other gets replaced.

**A format that failed silently.** Timeline entries only parsed in one
exact shape. Anything else was ignored with no error and no log. I found
out by noticing absences, which is the worst way to find anything out.

**A security control that failed open.** Three code paths in my injection
scanner returned "not blocked" when the scan produced no verdict at all.
The comment above one of them said "fail closed." The code did the
opposite. High-risk sources, email and external links, were exactly the
ones sailing through.

**A router that was never running.** I built a classifier-based message
router, wrote about it as a live system, and then discovered while
preparing a demo that nothing referenced it, it could not import, and its
model map pointed at models that no longer exist. I had described dead
code as production. I corrected it publicly rather than quietly, because
the correction is the interesting part.

**Infrastructure I had to kill.** An earlier component worked well enough
that I built twenty-two tools against it. I removed all of it and rewired
everything, because running two sources of truth is how you end up with
zero. Killing working infrastructure you built yourself is a specific
discipline, and it is the one that keeps a one-person system from
becoming a museum.

---

## Chapter 8: What transfers

If you are making these decisions for a team rather than a personal
setup, four things carried over cleanly.

**Separate the judge from the target.** Any component asked to evaluate
content is compromised by holding that content. This goes well beyond
prompt injection. It is the same reason you do not let a service grade
its own health check.

**Control the exits, not the decisions.** You cannot make a probabilistic
system reliably choose not to leak. You can enumerate every place data
leaves and filter all of them. Decisions are probabilistic. Exits are
countable.

**Route by verifiability, not by cost.** "Use the cheap model where
possible" produces the wrong answer, because the cheapest place to use it
is often the highest-stakes step. Ask instead which steps you can verify
cheaply, and put the weak model there.

**A finding you cannot act on in one step is not a finding.** Every
monitoring system I have watched fail, failed by producing more signal
than anyone would triage. My health reporter delivers a numbered digest
where every item drills to full evidence and heals with one command.
That is not a convenience feature. It is what makes the alerts survive
contact with a busy week.

---

## The uncomfortable version

I built a fleet of agents with broad access first, and designed the
security posture second. That is the honest sequence. It is also the
sequence most companies are following with agents right now, and the only
difference that means anything is whether the second step ever happens.

I am not an engineer. I spent fifteen years leading product teams and
shipping through other people: signup-to-activation from 11 to 31 percent
in four months, a fifty percent lift in qualified conversion, a product
relaunch that booked $650K before it fully launched. Good work, all of it
done by specifying and persuading rather than building.

In 2025 I stopped waiting for engineering capacity and started building
it myself. The result is not elegant. It is sixty-nine scheduled jobs
held together by watchdogs, a memory layer I fought into reliability, and
a security posture that exists because I kept finding my own outages by
accident and decided that finding them should be somebody's standing job.

But it runs. It has been running for months. And every design decision in
it traces back to a specific way I fail, measured rather than assumed,
which turns out to be a reasonable way to build software for anyone.

---

*The full architecture map, all five case studies, and links to the
public code are at
[github.com/JustinTSmith/systems](https://github.com/JustinTSmith/systems).*

*Justin Smith is a product leader who ships AI systems. Squamish, BC.
[justintsmith.github.io](https://justintsmith.github.io)*
