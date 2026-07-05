# Freund — German conversation partner

Chat with an AI friend in German who **corrects you as you go** and, at the end,
**banks your mistakes as flashcards** that flow into the normal Words loop. Built
as an additive AI module (like the tutor) — the core SRS loop is untouched.

## The loop

- New tab **Freund 🗣️** (`/freund`), a chat like the tutor. The learner writes in
  German; Freund replies.
- **Every message** produces three things (`POST /freund/message`, one forced
  `respond` tool call on **Haiku 4.5** for low latency):
  1. `explanation` — a short English note on the mistakes (yellow bubble). Null → no
     issues, not rendered.
  2. `correction` — Freund returns the corrected sentence; the **server computes a
     word-level diff** (`server/freund/diff.ts`, pure + tested) against what the
     learner typed, returned as `CorrectionSegment[]` (`keep`/`del`/`ins`) and
     rendered as `Ich ~~ist~~ *bin* müde`. Null → already correct / not German.
  3. `reply` — Freund's German answer; keeps the conversation going with follow-ups
     and adapts complexity to how the learner is doing (it sees the whole transcript).
- **Seeding:** the system prompt is seeded server-side (`server/freund/seed.ts`) with
  the words + verbs the learner is practicing today, so Freund weaves them in when it
  fits — never forced. This query reads the German answers, which is why it stays
  server-side (the review APIs never send answers to the client).
- **End conversation** → `POST /freund/review` (**Opus 4.8**, `suggest_cards` tool)
  reviews the transcript and proposes cards for what the learner got wrong. The
  learner **accepts/rejects** each (or rejects all); accepted cards are saved via
  `POST /freund/cards` into a single shared **"Freund cards"** deck
  (`source='freund'`, created on first use, reused across all conversations).

## Notes / gotchas

- **Stateless, like the tutor.** The client holds the transcript and replays it each
  turn; nothing is persisted. A refresh loses the in-progress conversation.
- Only Freund's German replies are replayed as history — the corrections/explanations
  are display-only metadata the model re-derives.
- **The review call flattens the transcript into one user message.** The conversation
  always ends on Freund's (assistant) turn, and the 4.x+ models reject a request
  ending on an assistant message (it reads as a prefill). Analysis-of-a-transcript is
  a natural fit for a single user message anyway.
- Both AI calls use a **forced tool call** rather than structured outputs — rock-solid
  across models and matches the tutor's pattern. The route reads the tool `input`.
- Models are pinned in `server/freund/agent.ts` (`CHAT_MODEL`, `REVIEW_MODEL`).

## Files

`server/freund-routes.ts` (thin routes) · `server/freund/agent.ts` (models, tool
schemas, prompts) · `server/freund/diff.ts` + `diff.test.ts` · `server/freund/seed.ts`
(today's-vocab query) · `web/src/freund.tsx` · client wiring in `api.ts`, `footer.tsx`,
`app.tsx`.
