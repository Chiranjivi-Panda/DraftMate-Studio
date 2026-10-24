# 📋 DraftMate Studio — Project Status & Full Structure

> Team handoff document. Read this first. Last updated: Sun 25 Oct 2026, ~00:15 IST.
> Event: Kodekurrent Season 2 · RGIPT Amethi · 12-hour build · Team of 4

---

## 1. What we are building (one paragraph)

**DraftMate Studio** is an AI legal drafting workspace. A user uploads a reference draft, picks (or speaks) a legal skill, gets a draft in their own style, sees every citation verified as ✅ Verified / 🟡 Partial / 🔴 Unverified with source links, edits by voice with confirmation before destructive actions, and exports to DOCX/PDF. Human review stays central. Full pitch, architecture and demo script are in `README.md`.

---

## 2. What has happened so far

| # | Step | Status |
|---|---|---|
| 1 | Problem statement analysed (see `Legal Drafting Studio` PS) | ✅ Done |
| 2 | Project name chosen: **DraftMate Studio** | ✅ Done |
| 3 | Full `README.md` written: architecture, stack, skills framework, verification engine, voice agent, token optimisation, team split, 12-hr timeline, demo script, judge Q&A, deployment | ✅ Done |
| 4 | Work divided equally among 4 members (1 hard + 1 medium + 1 polish each) | ✅ Done |
| 5 | **Member 1 (Frontend) — complete first version** generated as `setup_frontend.sh` (creates 49 files) | ✅ Done |
| 6 | Frontend verified: `npm install` OK, `tsc --noEmit` passes with **0 errors** | ✅ Done |
| 7 | Frontend `next build` | ⚠️ Not verified in our sandbox (it could not download Google Fonts). Should work on a normal internet connection — **run `npm run build` once locally** |
| 8 | Frontend viewed in a real browser | ⚠️ Not yet — first person to run it should check and report visual bugs |
| 9 | Backend (Members 2, 3, 4) | ⏳ Not started in this thread |
| 10 | Deployment | ⏳ Not started |

### Key design decisions already made
1. **Frontend runs standalone on built-in demo data.** `lib/api.ts` pings `GET /api/health`; if the backend answers, the UI goes **live**, otherwise it uses mock data. Any failing live call falls back to demo data automatically → the demo can't crash on stage.
2. **Single data contract** in `frontend/lib/types.ts` — backend must return exactly these shapes.
3. **Citations are marker-based.** The LLM must emit `[CITE: Section 138, NI Act, 1881]` for every authority. The editor converts markers into highlighted spans; the verifier checks each one.
4. **Draft is streamed as Markdown** over SSE; the frontend converts it to HTML for the TipTap editor.
5. **Voice = browser Web Speech API** (Chrome/Edge). Every transcript goes through the same `runInstruction()` as typed commands.
6. **Destructive intents (`delete`, `overwrite`) always open a confirm modal** — also answerable by voice ("confirm"/"cancel").
7. **All workflow logic lives in `lib/actions.ts`, all network calls in `lib/api.ts`** — components are presentational only, so teammates rarely need to touch UI files.

---

## 3. Team ownership

| Member | Role | Owns |
|---|---|---|
| **M1** | Frontend & UX | `frontend/` — ✅ first version delivered; now: polish, integration, bug-fixing |
| **M2** | AI Core & Skills | `backend/core/llm_gateway.py`, `skill_engine.py`, `style_profiler.py`, `skills/*.yaml`; endpoints `/api/skills`, `/api/route`, `/api/draft`, `/api/edit` |
| **M3** | Verification & Context | `backend/verification/*`, `backend/core/context_manager.py`; endpoint `/api/verify`; token usage numbers; 15-citation demo test set |
| **M4** | Voice, Docs & DevOps | `backend/core/doc_pipeline.py`, `export/*`, `voice_agent.py` (optional server side), `/api/upload`, `/api/export`, Docker, deployment, demo video |

---

## 4. Complete project structure (end to end)

Legend: ✅ exists now · ⏳ to be built by the owner shown

```
draftmate-studio/
├── README.md                          ✅ pitch + architecture + plan
├── PROJECT_STATUS.md                  ✅ this file
├── setup_frontend.sh                  ✅ regenerates the whole frontend folder
├── docker-compose.yml                 ⏳ M4
├── .env.example                       ⏳ M4  (ANTHROPIC_API_KEY, OPENAI_API_KEY, GEMINI_API_KEY,
│                                              INDIANKANOON_TOKEN, DEFAULT_MODEL, CORS_ORIGINS)
│
├── frontend/                          ✅ M1  (Next.js 14 · TypeScript · Tailwind · TipTap · Framer Motion)
│   ├── package.json · tsconfig.json · next.config.mjs · postcss.config.mjs · tailwind.config.ts
│   ├── .env.local.example             NEXT_PUBLIC_API_URL, NEXT_PUBLIC_API_MODE (auto|mock|live)
│   ├── INTEGRATION.md                 endpoint contract for backend teammates
│   ├── app/
│   │   ├── layout.tsx                 fonts, theme provider, metadata
│   │   ├── page.tsx                   renders <Workspace/>
│   │   └── globals.css                theme variables, paper/editor styles, citation colours, animations
│   ├── lib/
│   │   ├── types.ts                   ★ SHARED DATA CONTRACT (Skill, Citation, DraftEvent, RouteResult…)
│   │   ├── api.ts                     ★ every backend call (live + demo fallback)
│   │   ├── actions.ts                 ★ workflows: runInstruction, runDraft, runVerify, runEdit,
│   │   │                                 doDelete, exportDoc, uploadFiles, runDemo, confirm handling
│   │   ├── store.ts                   global state (zustand)
│   │   ├── voice.ts                   Web Speech hook + confirm-by-voice (M4 may extend)
│   │   ├── speech.ts                  speech synthesis read-back
│   │   ├── mock.ts                    demo skills, drafts, citation results, intent router
│   │   ├── citations.ts               [CITE: …] → highlighted spans + ordered citation list
│   │   ├── md.ts                      tiny Markdown → HTML converter
│   │   ├── html.ts                    DOM helpers (find/remove/rewrite paragraph)
│   │   └── tiptap-citation.ts         custom TipTap mark carrying citation id + status
│   └── components/
│       ├── Workspace.tsx              3-pane grid + global overlays
│       ├── layout/
│       │   ├── TopBar.tsx             logo, title, status chip, demo/live chip, model, export, theme
│       │   ├── LeftPane.tsx           upload zone + skill library
│       │   ├── CenterPane.tsx         editor ↔ empty state + command bar
│       │   └── RightPane.tsx          verification + token meter + human-review checklist
│       ├── DraftEditor.tsx            TipTap editor, streaming, citation highlighting, toolbar
│       ├── CommandBar.tsx             text input, skill chip, suggestions, mic, stop/send, ⌘/Ctrl+K
│       ├── VoiceControl.tsx           mic button + live transcript bubble + waveform
│       ├── SkillLibrary.tsx / SkillIcon.tsx   searchable, category-filtered skill cards
│       ├── UploadZone.tsx             drag-drop, conversion status, learned style profile
│       ├── VerificationPanel.tsx      summary ring, filter tabs, citation cards, re-verify
│       ├── CitationCard.tsx / SummaryRing.tsx
│       ├── TokenMeter.tsx             raw vs sent tokens, animated "% saved"
│       ├── ReviewChecklist.tsx        "Reviewed by advocate" checklist
│       ├── ConfirmModal.tsx           confirm for delete/overwrite (voice-aware)
│       ├── StatusToasts.tsx           live task feedback
│       ├── ModelSelector.tsx          Claude / GPT / Gemini
│       ├── EmptyState.tsx             typewriter hero + "Run guided demo"
│       ├── Splash.tsx · Logo.tsx · AnimatedBackground.tsx · ThemeToggle.tsx
│       ├── ThemeProvider.tsx · MobileTabs.tsx
│
├── backend/                           ⏳ M2 / M3 / M4  (FastAPI, Python 3.11)
│   ├── main.py                        app, CORS, router include, GET /api/health  (M4 creates skeleton FIRST)
│   ├── requirements.txt
│   ├── Dockerfile                     M4
│   ├── models.py                      Pydantic/SQLModel schemas mirroring frontend/lib/types.ts
│   ├── api/
│   │   ├── skills.py                  GET  /api/skills                    (M2)
│   │   ├── route.py                   POST /api/route                     (M2)
│   │   ├── draft.py                   POST /api/draft   (SSE)             (M2)
│   │   ├── edit.py                    POST /api/edit                      (M2)
│   │   ├── verify.py                  POST /api/verify                    (M3)
│   │   ├── upload.py                  POST /api/upload                    (M4)
│   │   ├── export.py                  POST /api/export?fmt=docx|pdf       (M4)
│   │   └── voice.py                   WS   /api/voice  (optional)         (M4)
│   ├── core/
│   │   ├── llm_gateway.py             Claude/GPT/Gemini abstraction, streaming     (M2)
│   │   ├── skill_engine.py            YAML loader, router, chaining                (M2)
│   │   ├── style_profiler.py          tone/structure/terms/clauses → style card    (M2)
│   │   ├── context_manager.py         chunk, BM25 retrieve, compress, token count  (M3)
│   │   ├── doc_pipeline.py            MarkItDown wrapper                           (M4)
│   │   └── voice_agent.py             intent parser / confirm gate (server side)   (M4)
│   ├── verification/
│   │   ├── extractor.py               regex + LLM citation extraction              (M3)
│   │   ├── sources/ indiankanoon.py · indiacode.py · websearch.py                  (M3)
│   │   ├── matcher.py                 fuzzy match + LLM judge on retrieved text    (M3)
│   │   └── scorer.py                  verified / partial / unverified + confidence (M3)
│   ├── export/ docx_export.py · pdf_export.py                                      (M4)
│   └── tests/
│
├── skills/                            ⏳ M2  — 10 YAML skills (legal_notice, contract_drafting, agreement,
│                                              petition, contract_review, redlining, due_diligence,
│                                              legal_research, case_analysis, summarisation)
├── samples/                           ⏳ M3/M4 — sample reference notice, test citations (real/partial/fake)
└── docs/                              ⏳ M4 — architecture.png, demo-script.md, screenshots
```

---

## 5. How to run what exists today

```bash
# one-time, from repo root
bash setup_frontend.sh                 # SKIP_INSTALL=1 to skip npm install
cd frontend && npm run dev             # http://localhost:3000
```

With **no backend running**, the app is fully usable in **Demo mode** (chip in the top bar):
click **Run guided demo** → sample upload → streamed notice → 5 citations verified (3 ✅, 1 🟡, 1 🔴) → token meter → try typing/speaking *"Make paragraph 3 more formal"*, *"Delete paragraph 5"* (confirm modal), *"Verify all citations"*, *"Export as Word"*.

When a backend answers `/api/health`, the chip switches to **Live backend** automatically. Force a mode with `NEXT_PUBLIC_API_MODE=mock|live` in `frontend/.env.local`.

---

## 6. 🔌 Backend contract (M2 / M3 / M4 — implement exactly this)

Full details in `frontend/INTEGRATION.md` and `frontend/lib/types.ts`.

| Owner | Endpoint | Request → Response |
|---|---|---|
| M4 | `GET /api/health` | `200 {"ok": true}` — **do this in the first 30 min** |
| M2 | `GET /api/skills` | `Skill[]` `{id,name,category,description,triggers[],example?,requires_verification?}` |
| M2 | `POST /api/route` | `{instruction, has_draft}` → `{intent, skill_id?, paragraph?, text?}`; intent ∈ `draft, edit, verify, export, delete, overwrite, dictate` |
| M2 | `POST /api/draft` (SSE) | `{instruction, skill_id, model, doc_ids}` → frames `data: {"type":"skill","skill_id":"…"}`, `{"type":"token","text":"…"}`, `{"type":"usage","raw":N,"sent":N}`, `{"type":"done"}` |
| M2 | `POST /api/edit` | `{instruction, html, model, paragraph?}` → `{html, summary}` |
| M3 | `POST /api/verify` | `{citations:[{id,text,kind}]}` → `{citations: Citation[]}` with `status, confidence, source_name, source_url, snippet, note, suggestion` |
| M4 | `POST /api/upload` | multipart `file` → `{id, name, size, tokens, style:{tone,structure,terminology[],clausePatterns[],formatting}}` |
| M4 | `POST /api/export?fmt=docx\|pdf` | `{title, html, citations}` → file blob (include Verification Summary) |

**Non-negotiable rules**
1. The model emits every authority as `[CITE: …]`.
2. Draft streams as Markdown; numbered paragraphs are plain `1. text` lines separated by blank lines (the voice command "paragraph 3" depends on that).
3. CORS must allow `http://localhost:3000` and the Vercel domain.
4. Never invent authorities — unverified ones must be returned as `unverified`, not removed.

---

## 7. Next steps by member

### M1 — Frontend (now)
- [ ] Run `npm run dev` and `npm run build` locally; fix any visual/runtime bug found
- [ ] Test on phone width and in light mode
- [ ] Take screenshots for README and slides
- [ ] Once backends land: test live mode end to end, tune SSE edge cases
- [ ] Stretch: redline diff view, Hindi UI labels

### M2 — AI Core & Skills
- [ ] FastAPI skeleton agreement with M4 (shared `main.py`)
- [ ] `llm_gateway.py` with streaming for Claude (add GPT/Gemini after)
- [ ] `skill_engine.py` + 10 YAMLs; make `/api/skills` match the contract
- [ ] `/api/draft` SSE exactly as in §6; prompt forces `[CITE: …]`
- [ ] `/api/route` intent classifier; `/api/edit`; style profile injection

### M3 — Verification & Context
- [ ] `extractor.py` (regex for AIR/SCC/Section/Order-Rule + LLM fallback)
- [ ] One working source first (Indian Kanoon), then India Code, then web search
- [ ] `matcher.py` + `scorer.py` producing the 3 statuses with snippets and links
- [ ] `context_manager.py`: chunk → BM25 → compress; return real `raw`/`sent` token counts
- [ ] Curate 15 demo citations (real / partial / fake) in `samples/`

### M4 — Voice, Docs & DevOps
- [ ] Backend skeleton + `/api/health` + CORS (first 30 minutes — unblocks everyone)
- [ ] `/api/upload` with MarkItDown; `/api/export` DOCX + PDF
- [ ] Review/extend `frontend/lib/voice.ts` (Whisper fallback optional)
- [ ] Dockerfile + `docker-compose.yml` + `.env.example`
- [ ] Deploy: Vercel (frontend) + Render/Railway (backend); record backup demo video

---

## 8. Timeline reminder

| Hours | Goal |
|---|---|
| 0:00–0:45 | Repo, contracts, skeleton running |
| 0:45–3:30 | Hard modules built in parallel (frontend already ahead of schedule) |
| 3:30–4:00 | **Checkpoint 1:** upload → draft → editor |
| 4:00–7:00 | Medium modules + wiring |
| 7:00–7:30 | **Checkpoint 2:** full demo path dry run |
| 7:30–9:30 | Polish, remaining skills, export, error handling |
| 9:30–10:30 | **Deploy** + bug bash |
| 10:30–11:30 | Rehearse ×3, backup video, slides |
| 11:30–12:00 | **Code freeze**, final test on venue Wi-Fi, submit |

---

## 9. Known risks / honest limitations

- Frontend was type-checked but **not yet seen in a browser** by us; expect small visual fixes.
- Demo citation results in `lib/mock.ts` are **scripted**; real verification depends on M3's engine and source availability. Paid databases (SCC Online, Manupatra) are not accessible — "Unverified" means *not found in accessible sources*, not *fake*. Say this openly in the demo.
- Web Speech API works in **Chrome/Edge only**; the text command bar is always available as backup.
- Free-tier backends sleep — warm up before presenting; keep Docker-on-laptop and a recorded video as fallbacks.
- Export in demo mode is a Word-compatible `.doc` / print-to-PDF until M4's real export is live.

---

## 10. Team rules

Merge small and often · feature branches · one person owns `main` · **freeze at 11:30** · never break the contract in `types.ts` without telling everyone · AI-assisted drafts are not legal advice and require advocate review.
