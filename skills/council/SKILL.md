---
name: council
description: "5-advisor war room for high-stakes decisions. Independent analysis → anonymous peer review → chairman verdict with confidence scoring, kill criteria, and decision rules. MANDATORY TRIGGERS: 'council this', 'run the council', 'war room this', 'pressure-test this', 'stress-test this', 'debate this', 'force council'. STRONG TRIGGERS (with real stakes): 'should I X or Y', 'which option', 'is this the right move', 'validate this', 'I can't decide', 'I'm torn between'. DO NOT trigger on factual lookups, casual questions, or low-stakes choices."
---

# Council

5 independent advisors. Anonymous peer review. Chairman verdict. Two files out.

Skip this for facts, simple tasks, or anything with one right answer. Use it when being wrong costs money, time, or reputation.

---

## The Five Advisors

1. **Contrarian** — Assumes fatal flaw exists. Finds it. Not pessimism — risk surgery.
2. **First Principles** — Strips assumptions. Rebuilds from ground truth. Often declares wrong question being asked.
3. **Expansionist** — Obsessed with 10x upside and hidden leverage. Ignores risk entirely.
4. **Outsider** — Zero domain knowledge. Responds only to what's written. Catches curse-of-knowledge instantly.
5. **Executor** — Monday morning or it doesn't exist. First steps, timelines, friction points.

Three tensions: Contrarian vs Expansionist. First Principles vs Executor. Outsider keeps everyone honest.

---

## Council Modes

| Mode | Trigger | What Changes |
|------|---------|-------------|
| **Full Council** | Default | All 6 phases, peer review, full report |
| **Rapid Council** | "rapid council" / "quick council" | Skip peer review. Advisors → Chairman direct. 60% faster. |
| **War Room** | "war room this" | Contrarian + Executor get 2x weight. Aggressive. For defensive decisions. |

---

## Execution Protocol

Do not output anything to the user until Phase 5. All work is internal until the verdict.

### Phase 0: Stakes Assessment

Classify before anything else:

| Level | Criteria | Depth |
|-------|----------|-------|
| **Low** | Reversible, <₹1L impact, no reputation risk | Rapid Council auto-selected |
| **Medium** | Some cost, recoverable, moderate risk | Full Council |
| **High** | ₹10L+, reputation, strategic pivot, hard to undo | Full Council + extended peer review |

Adjust advisor depth and Contrarian intensity based on stakes.

**Reversibility check:**
- Reversible decision → bias toward action, lower confidence threshold acceptable
- Irreversible decision → require >75% confidence before recommending. If below, default to "gather more data"

### Phase 0.5: Time Horizon

Classify the decision timeframe before framing:

| Horizon | Timeframe | Effect |
|---------|-----------|--------|
| **Immediate** | 0-30 days | Executor + Contrarian get priority |
| **Short-term** | 1-3 months | Balanced council |
| **Long-term** | 6-12+ months | First Principles + Expansionist get priority |

All advisors must align recommendations to the identified horizon. A 30-day decision gets 30-day advice, not 5-year vision.

### Phase 1: Context Enrichment + Information Sufficiency Gate

**A. Scan workspace** (30 seconds max):
- `CLAUDE.md` in project root (business context, constraints)
- `memory/` folder (audience, past decisions, numbers)
- Referenced files, recent council transcripts
- Use `Glob` and quick `Read`. Find 2-3 files max.

**B. Information sufficiency check:**
- Do we have enough to answer this well?
- What critical inputs are missing?
- If missing critical data: ask MAX 2 targeted questions, then proceed
- If proceeding with gaps, list explicit assumptions:

```
ASSUMPTIONS BEING MADE:
- [Assumption 1]
- [Assumption 2]
```

**C. Frame the question** — neutral, includes: core decision, key context, enriched context from files, what's at stake, past relevant decisions if any. Save for transcript.

### Phase 2: Convene Advisors (5 sub-agents in parallel)

Spawn all 5 simultaneously. Each gets their identity + framed question + these rules:

```
You are [Advisor Name] on a decision council.

Your thinking style: [description]

Question:
---
[framed question with enriched context]
---

RULES:
- Be direct. No hedging. No "on one hand / on the other hand."
- Lean 100% into your assigned angle. The other advisors cover what you don't.
- 150-280 words. No preamble. Straight into analysis.
- Name specific numbers, names, timelines — not abstractions.
- Do NOT reference other advisors. You haven't seen their work.
```

**Dynamic emphasis based on problem type:**
- Strategic decision → boost First Principles + Expansionist intensity
- Execution decision → boost Executor + Contrarian
- Market/customer facing → boost Outsider
- Risk-heavy → boost Contrarian

**Mandatory Decision Matrix criteria** (used by Chairman in Phase 4):
- ROI Potential
- Speed to Impact
- Execution Complexity
- Risk Exposure

Add domain-specific criteria only if needed. These 4 are always present.

### Phase 3: Anonymous Peer Review (5 sub-agents in parallel)

Skip this phase if Rapid Council mode.

Collect 5 responses. Randomize mapping to letters A-E. Each reviewer sees all 5 anonymized responses.

```
You are reviewing 5 anonymous council responses to this question:
---
[framed question]
---

Responses A through E:
[all 5]

Answer these 3 questions. Be specific. Reference by letter.

1. STRONGEST response? Score it 1-10. Why?
2. BIGGEST BLIND SPOT in any response? Score severity 1-10. What's missing?
3. What did ALL responses miss? Score the collective gap 1-10.

Under 200 words. Direct.
```

### Phase 3.5: Targeted Rebuttal (Fast Pass)

Skip if Rapid Council mode.

After peer review, each advisor gets ONE shot (max 80 words):
- Defend against the strongest criticism of their position, OR
- Update their position based on what peer review revealed

No new analysis. Only correction or reinforcement. This sharpens weak arguments and forces advisors to engage with criticism instead of ignoring it.

Spawn all 5 in parallel. Each sees only the peer review comments about their own response (de-anonymized for this step only).

### Phase 4: Chairman Synthesis

Chairman receives everything (de-anonymized + rebuttals) and produces the verdict.

```
You are the Chairman. Synthesize 5 advisor responses, 5 peer reviews, and 5 rebuttals into a decisive verdict.

You do NOT compromise. If 1 advisor is right and 4 are wrong, side with the 1 and explain why.

BIAS CONTROL (mandatory before writing verdict):
Check if any advisor is:
- Over-indexing on their role (Contrarian always negative, Expansionist always bullish)
- Ignoring key evidence that contradicts their angle
- Producing a predictable take instead of a genuine one
Correct for excess pessimism, unrealistic upside, or over-abstraction before synthesizing.

Question:
[framed question]

Advisor responses:
[all 5, labeled by name]

Rebuttals:
[all 5, 80 words each]

Peer reviews:
[all 5, with scores]

Produce the verdict in the EXACT structure provided. No hedging. Make a call.
```

### Phase 5: Output the Verdict

Display to user in this exact format:

```markdown
# Council Verdict

**Stakes:** [Low / Medium / High]
**Confidence:** [X%] — [one line explaining why]
  ↳ Derived from: Data completeness (0-40%) + Advisor alignment (0-30%) + Assumption stability (0-30%). Do NOT guess. Calculate.
**Mode:** [Full / Rapid / War Room]

## Where the Council Agrees
[Points multiple advisors converged on independently. High-confidence signals.]

## Where the Council Clashes
[Present both sides raw. Name which advisors and why they disagree.]

## Blind Spots Caught in Review
[Only visible after peer review. What individual advisors missed.]

## Second-Order Effects
[What happens AFTER the decision. Downstream consequences nobody mentioned.]

## Decision Matrix

| Option | [Criteria 1] | [Criteria 2] | [Criteria 3] | [Risk] | **Total** |
|--------|-------------|-------------|-------------|--------|-----------|
| Option A | X/10 | X/10 | X/10 | X/10 | XX/40 |
| Option B | X/10 | X/10 | X/10 | X/10 | XX/40 |

## The Recommendation
[Clear. Decisive. No "it depends." If the data supports a minority view, side with it and explain why.]

## Decision Rules
- If [condition X] → Do A
- If [condition Y] → Do B
- If unclear → Do C

## Kill Criteria
Stop or pivot if:
- [Specific signal 1]
- [Specific signal 2]

## The One Thing to Do First
[Single concrete action. Not a list. One thing. With a deadline.]

## If This Fails
The most likely reason this recommendation fails:
- [Single dominant failure reason]
- [What early warning signal to watch for]

## Re-run Conditions
Re-run the council if:
- New data changes a core assumption
- Early execution signals contradict the recommendation
- Market conditions shift significantly
- More than [timeframe] passes without action

---

## Decision Integrity Check
- **Data completeness:** [High / Medium / Low]
- **Advisor alignment:** [Strong / Mixed / Weak]
- **Fragile assumptions:** [list them]
- **When NOT to follow this recommendation:** [specific scenarios]
```

Then show collapsible full transcripts:

```markdown
<details>
<summary><b>Full Advisor Responses (click to expand)</b></summary>

**Contrarian:** [full response]
**First Principles:** [full response]
**Expansionist:** [full response]
**Outsider:** [full response]
**Executor:** [full response]

</details>

<details>
<summary><b>Peer Review Scores (click to expand)</b></summary>

[All 5 reviews with scores]
Anonymization mapping: A=[name], B=[name], C=[name], D=[name], E=[name]

</details>
```

### Phase 6: Save Files

**File 1:** `council-report-[YYYY-MM-DD-HHMM].md` — the verdict above
**File 2:** `council-transcript-[YYYY-MM-DD-HHMM].md` — full transcript including framed question, all advisor responses, all peer reviews with anonymization mapping, chairman reasoning, stakes assessment, assumptions made

Save both to the current working directory.

If a previous council transcript exists for a similar topic, reference it in the framing ("Previous council on [date] recommended X. Has context changed?").

---

## Post-Decision Tracking

At the end of every verdict, append:

```markdown
## Track This Decision (fill in later)
- **Decision taken:**
- **Outcome:**
- **What worked:**
- **What the council got wrong:**
- **Lesson for future councils:**
```

This turns the council from a one-shot tool into a learning system. Past outcomes improve future framing.

---

## Pattern Recognition Layer

If previous council transcripts exist in the working directory, scan them during Phase 1:

- Similar situation seen before? Reference it.
- What worked / failed in past council recommendations?
- Is this decision repeating a known mistake?
- If pattern detected → flag it in the framing and let advisors account for it.
- **If a strong negative pattern is detected** (same decision previously failed): Chairman MUST explicitly justify why this time is different, OR recommend against repeating the decision.

This is the compounding advantage. Every council run makes the next one sharper.

---

## Rules

- All 5 advisors spawn in parallel. Never sequential.
- Always anonymize for peer review. Positional bias is real.
- Chairman CAN disagree with majority. Reasoning > headcount.
- Don't council trivial questions. Just answer them.
- If the user says "force council" on a trivial question, run it anyway.
- Context enrichment is mandatory. Don't let advisors work blind when files exist.
- Every number in the verdict must be justified, not invented.
