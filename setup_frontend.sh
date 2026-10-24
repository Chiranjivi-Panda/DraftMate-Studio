#!/usr/bin/env bash
# DraftMate Studio — Frontend scaffold (Member 1)
# Run from the repo root:  bash setup_frontend.sh
# Set SKIP_INSTALL=1 to skip `npm install`.
set -e

echo "▶ Creating folder tree..."
mkdir -p frontend/app frontend/lib frontend/components/layout frontend/public

echo "▶ Writing files..."

# ───────────────────────────── CONFIG ─────────────────────────────
cat > frontend/package.json <<'DMEOF'
{
  "name": "draftmate-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@tiptap/core": "^2.8.0",
    "@tiptap/extension-placeholder": "^2.8.0",
    "@tiptap/pm": "^2.8.0",
    "@tiptap/react": "^2.8.0",
    "@tiptap/starter-kit": "^2.8.0",
    "clsx": "^2.1.1",
    "framer-motion": "^11.11.0",
    "lucide-react": "~0.453.0",
    "next": "14.2.15",
    "next-themes": "^0.3.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "zustand": "^4.5.5"
  },
  "devDependencies": {
    "@types/node": "^20.16.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "autoprefixer": "^10.4.20",
    "postcss": "^8.4.47",
    "tailwindcss": "^3.4.14",
    "typescript": "^5.6.0"
  }
}
DMEOF

cat > frontend/tsconfig.json <<'DMEOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
DMEOF

cat > frontend/next.config.mjs <<'DMEOF'
/** @type {import('next').NextConfig} */
const nextConfig = { reactStrictMode: true };
export default nextConfig;
DMEOF

cat > frontend/postcss.config.mjs <<'DMEOF'
export default { plugins: { tailwindcss: {}, autoprefixer: {} } };
DMEOF

cat > frontend/tailwind.config.ts <<'DMEOF'
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}", "./lib/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        bg: "rgb(var(--bg) / <alpha-value>)",
        panel: "rgb(var(--panel) / <alpha-value>)",
        line: "rgb(var(--line) / <alpha-value>)",
        fg: "rgb(var(--fg) / <alpha-value>)",
        muted: "rgb(var(--muted) / <alpha-value>)",
        accent: "rgb(var(--accent) / <alpha-value>)",
        ink: { 950: "#070b14", 900: "#0b1220", 800: "#111a2e", 700: "#18233d" },
        gold: { 300: "#f1d9a0", 400: "#e6c274", 500: "#d4a64a", 600: "#b8892f" },
      },
      fontFamily: {
        sans: ["var(--font-inter)", "system-ui", "sans-serif"],
        display: ["var(--font-display)", "Georgia", "serif"],
        serif: ["var(--font-serif)", "Georgia", "serif"],
        mono: ["var(--font-mono)", "monospace"],
      },
    },
  },
  plugins: [],
};
export default config;
DMEOF

cat > frontend/.env.local.example <<'DMEOF'
# Backend base URL (FastAPI)
NEXT_PUBLIC_API_URL=http://localhost:8000
# auto  = use backend if /api/health responds, else built-in demo data (recommended)
# mock  = always demo data     live = always backend
NEXT_PUBLIC_API_MODE=auto
DMEOF

cat > frontend/.gitignore <<'DMEOF'
node_modules
.next
.env.local
next-env.d.ts
*.tsbuildinfo
DMEOF

# ───────────────────────────── APP ─────────────────────────────
cat > frontend/app/globals.css <<'DMEOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --bg: 246 243 236;
  --panel: 255 255 255;
  --line: 222 214 198;
  --fg: 17 24 39;
  --muted: 100 108 125;
  --accent: 160 115 28;
}
.dark {
  --bg: 7 11 20;
  --panel: 17 26 46;
  --line: 38 52 84;
  --fg: 232 236 245;
  --muted: 140 152 178;
  --accent: 230 194 116;
}

html, body { height: 100%; }
body {
  background: rgb(var(--bg));
  color: rgb(var(--fg));
  font-family: var(--font-inter), system-ui, sans-serif;
  -webkit-font-smoothing: antialiased;
  overflow: hidden;
}
::selection { background: rgb(var(--accent) / 0.3); }

@layer components {
  .glass {
    background: rgb(var(--panel) / 0.62);
    backdrop-filter: blur(18px) saturate(140%);
    -webkit-backdrop-filter: blur(18px) saturate(140%);
    border: 1px solid rgb(var(--line) / 0.7);
    box-shadow: 0 10px 40px -18px rgba(0, 0, 0, 0.35);
  }
  .btn {
    @apply inline-flex items-center gap-2 rounded-xl border border-line/70 bg-panel/60 px-3 py-2 text-sm font-medium text-fg transition hover:border-accent/60 hover:bg-panel disabled:pointer-events-none disabled:opacity-40;
  }
  .btn-icon {
    @apply inline-flex h-9 w-9 items-center justify-center rounded-xl border border-line/70 bg-panel/60 text-fg/80 transition hover:border-accent/60 hover:text-accent disabled:pointer-events-none disabled:opacity-40;
  }
  .btn-gold {
    @apply inline-flex items-center gap-2 rounded-xl bg-gradient-to-br from-gold-300 to-gold-500 px-3.5 py-2 text-sm font-semibold text-ink-950 shadow-[0_8px_30px_-8px_rgba(212,166,74,.6)] transition hover:brightness-110 active:scale-[.98] disabled:pointer-events-none disabled:opacity-40;
  }
  .chip {
    @apply inline-flex items-center gap-1.5 rounded-full border border-line/70 bg-panel/50 px-2.5 py-1 text-[11px] font-medium text-muted;
  }
  .label {
    @apply text-[11px] font-semibold uppercase tracking-[0.14em] text-muted;
  }
}

.scroll-thin { scrollbar-width: thin; scrollbar-color: rgb(var(--line)) transparent; }
.scroll-thin::-webkit-scrollbar { width: 8px; height: 8px; }
.scroll-thin::-webkit-scrollbar-thumb { background: rgb(var(--line)); border-radius: 99px; }

/* ── Animated background ── */
.bg-grid {
  background-image:
    linear-gradient(rgb(var(--line) / 0.35) 1px, transparent 1px),
    linear-gradient(90deg, rgb(var(--line) / 0.35) 1px, transparent 1px);
  background-size: 44px 44px;
  mask-image: radial-gradient(ellipse at center, black 30%, transparent 75%);
  -webkit-mask-image: radial-gradient(ellipse at center, black 30%, transparent 75%);
}
.blob { position: absolute; border-radius: 9999px; filter: blur(90px); opacity: 0.35; animation: blob 22s ease-in-out infinite; }
@keyframes blob {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(60px, -40px) scale(1.15); }
  66% { transform: translate(-40px, 40px) scale(0.9); }
}
@keyframes shimmer { 0% { background-position: -200% 0; } 100% { background-position: 200% 0; } }
.shimmer {
  background: linear-gradient(90deg, transparent, rgb(var(--accent) / 0.22), transparent);
  background-size: 200% 100%;
  animation: shimmer 1.6s linear infinite;
}
@keyframes blink { 50% { opacity: 0; } }
@keyframes wave { 0%, 100% { transform: scaleY(0.25); } 50% { transform: scaleY(1); } }
.wave-bar { width: 3px; height: 18px; border-radius: 3px; background: currentColor; transform-origin: center; animation: wave 0.9s ease-in-out infinite; }
@keyframes gradientX { 0% { background-position: 0% 50%; } 100% { background-position: 200% 50%; } }
.ring-anim {
  background: linear-gradient(90deg, #d4a64a, #38bdf8, #a78bfa, #d4a64a);
  background-size: 200% 100%;
  animation: gradientX 5s linear infinite;
}
@keyframes ringPulse { 0% { box-shadow: 0 0 0 0 rgba(244, 63, 94, 0.55); } 100% { box-shadow: 0 0 0 16px rgba(244, 63, 94, 0); } }
.mic-live { animation: ringPulse 1.4s ease-out infinite; }
@keyframes scan { 0% { transform: translateX(-100%); } 100% { transform: translateX(100%); } }
.scanline { animation: scan 1.4s ease-in-out infinite; }

/* ── Legal paper & editor ── */
.paper {
  background: #fffdf8;
  color: #1c1917;
  border-radius: 8px;
  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.04), 0 40px 90px -40px rgba(0, 0, 0, 0.55);
  position: relative;
  overflow: hidden;
}
.legal-doc {
  font-family: var(--font-serif), Georgia, serif;
  font-size: 15.5px;
  line-height: 1.85;
  outline: none;
  padding: 56px 64px 80px;
  min-height: 560px;
}
@media (max-width: 640px) { .legal-doc { padding: 28px 22px 60px; } }
.legal-doc h1 { font-size: 1.65rem; text-align: center; letter-spacing: 0.16em; font-weight: 700; margin: 0 0 0.5rem; }
.legal-doc h2 { font-size: 1.2rem; font-weight: 700; margin: 1.4rem 0 0.4rem; }
.legal-doc h3 { font-size: 1.05rem; font-weight: 700; margin: 1rem 0 0.3rem; }
.legal-doc p { margin: 0 0 0.85rem; text-align: justify; }
.legal-doc ul { padding-left: 1.4rem; list-style: disc; margin-bottom: 0.85rem; }
.legal-doc hr { border: none; border-top: 1px solid #d6cfbf; margin: 1.2rem 0; }
.legal-doc p.is-editor-empty:first-child::before {
  content: attr(data-placeholder);
  color: #a8a29e; float: left; height: 0; pointer-events: none;
}
.streaming .legal-doc > :last-child::after {
  content: ""; display: inline-block; width: 2px; height: 1.1em; margin-left: 3px;
  vertical-align: -0.2em; background: #b8892f; animation: blink 1s steps(1) infinite;
}

/* ── Citation highlighting ── */
.cite {
  cursor: pointer; border-radius: 3px; padding: 0 2px;
  border-bottom: 2px solid; transition: background 0.35s, box-shadow 0.35s, border-color 0.35s;
}
.cite[data-status="pending"] { border-color: #d4a64a; background: rgba(212, 166, 74, 0.16); }
.cite[data-status="verified"] { border-color: #10b981; background: rgba(16, 185, 129, 0.14); }
.cite[data-status="partial"] { border-color: #f59e0b; background: rgba(245, 158, 11, 0.18); }
.cite[data-status="unverified"] { border-color: #f43f5e; background: rgba(244, 63, 94, 0.15); border-bottom-style: wavy; }
.cite.cite-active { box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.55); background: rgba(56, 189, 248, 0.18); }
DMEOF

cat > frontend/app/layout.tsx <<'DMEOF'
import type { Metadata } from "next";
import { Inter, Playfair_Display, Source_Serif_4, JetBrains_Mono } from "next/font/google";
import { ThemeProvider } from "@/components/ThemeProvider";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const display = Playfair_Display({ subsets: ["latin"], variable: "--font-display" });
const serif = Source_Serif_4({ subsets: ["latin"], variable: "--font-serif" });
const mono = JetBrains_Mono({ subsets: ["latin"], variable: "--font-mono" });

export const metadata: Metadata = {
  title: "DraftMate Studio — AI Legal Drafting, Verification & Voice",
  description: "Draft in your style. Verify every authority. Command it by voice.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning className={`${inter.variable} ${display.variable} ${serif.variable} ${mono.variable}`}>
      <body>
        <ThemeProvider attribute="class" defaultTheme="dark" enableSystem={false}>
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
DMEOF

cat > frontend/app/page.tsx <<'DMEOF'
import { Workspace } from "@/components/Workspace";

export default function Page() {
  return <Workspace />;
}
DMEOF

# ───────────────────────────── LIB ─────────────────────────────
cat > frontend/lib/types.ts <<'DMEOF'
// ── SHARED DATA CONTRACT ── (backend teammates: return exactly these shapes)
export type CitationStatus = "pending" | "verified" | "partial" | "unverified";
export type CitationKind = "case" | "statute" | "rule" | "other";
export type ModelId = "claude" | "gpt" | "gemini";
export type VoiceState = "idle" | "listening" | "processing" | "error";
export type Intent = "draft" | "edit" | "verify" | "export" | "delete" | "overwrite" | "dictate";

export interface Skill {
  id: string;
  name: string;
  category: string;
  description: string;
  triggers: string[];
  example?: string;
  requires_verification?: boolean;
  icon?: string;
}

export interface Citation {
  id: string;
  text: string;
  kind: CitationKind;
  status: CitationStatus;
  confidence: number; // 0..1
  source_name?: string;
  source_url?: string;
  snippet?: string;
  note?: string;
  suggestion?: string;
}

export interface StyleProfile {
  tone: string;
  structure: string;
  terminology: string[];
  clausePatterns: string[];
  formatting: string;
}

export interface UploadedDoc {
  id: string;
  name: string;
  size: number;
  status: "processing" | "ready" | "error";
  tokens?: number;
  style?: StyleProfile;
}

export interface TokenStats { raw: number; sent: number }

export interface ActivityItem { id: string; label: string; state: "running" | "done" | "error"; ts: number }

export interface ConfirmRequest {
  title: string;
  message: string;
  confirmLabel: string;
  danger?: boolean;
  onConfirm: () => void;
}

export interface RouteResult { intent: Intent; skill_id?: string; paragraph?: number; text?: string }

export interface DraftRequest { instruction: string; skillId?: string; model: ModelId; docIds: string[] }

// Server-Sent Events emitted by POST /api/draft  (each as `data: {json}\n\n`)
export type DraftEvent =
  | { type: "skill"; skill_id: string }
  | { type: "token"; text: string }
  | { type: "usage"; raw: number; sent: number }
  | { type: "done" }
  | { type: "error"; message: string };
DMEOF

cat > frontend/lib/md.ts <<'DMEOF'
// Tiny Markdown → HTML converter (headings, bold/italic, bullets, paragraphs).
const esc = (s: string) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

const inline = (s: string) =>
  esc(s)
    .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")
    .replace(/(^|[^*\w])\*([^*\s][^*]*?)\*(?!\*)/g, "$1<em>$2</em>");

export function mdToHtml(md: string): string {
  const out: string[] = [];
  let para: string[] = [];
  let list: string[] = [];
  const flushP = () => {
    if (para.length) { out.push(`<p>${para.map(inline).join("<br>")}</p>`); para = []; }
  };
  const flushL = () => {
    if (list.length) { out.push(`<ul>${list.map((i) => `<li><p>${inline(i)}</p></li>`).join("")}</ul>`); list = []; }
  };
  for (const line of md.split("\n")) {
    const l = line.trimEnd();
    let m: RegExpMatchArray | null;
    if (!l.trim()) { flushP(); flushL(); continue; }
    if ((m = l.match(/^(#{1,3})\s+(.*)$/))) {
      flushP(); flushL();
      out.push(`<h${m[1].length}>${inline(m[2])}</h${m[1].length}>`);
    } else if (/^---+$/.test(l.trim())) {
      flushP(); flushL(); out.push("<hr>");
    } else if ((m = l.match(/^[-*]\s+(.*)$/))) {
      flushP(); list.push(m[1]);
    } else {
      flushL(); para.push(l);
    }
  }
  flushP(); flushL();
  return out.join("");
}
DMEOF

cat > frontend/lib/citations.ts <<'DMEOF'
import { mdToHtml } from "./md";
import type { Citation, CitationKind } from "./types";

// Backend/LLM must wrap every authority as  [CITE: Section 138, NI Act, 1881]
const RE = /\[CITE:\s*([^\]]+?)\s*\]/g;

export function classify(t: string): CitationKind {
  if (/\bv\.?\s|\bvs\.?\s/i.test(t)) return "case";
  if (/\b(section|sec\.|s\.|article)\s*\d+/i.test(t)) return "statute";
  if (/\b(order|rule)\s+[ivxlc\d]+/i.test(t)) return "rule";
  return "other";
}

const unesc = (s: string) => s.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">");

/** Markdown draft (with [CITE: …] markers) → editor HTML + ordered citation list. IDs: c1, c2 … */
export function buildHtml(raw: string): { html: string; citations: Citation[] } {
  const ids = new Map<string, string>();
  const citations: Citation[] = [];
  const html = mdToHtml(raw).replace(RE, (_m, t: string) => {
    const key = t.trim();
    let id = ids.get(key);
    if (!id) {
      id = `c${ids.size + 1}`;
      ids.set(key, id);
      citations.push({ id, text: unesc(key), kind: classify(unesc(key)), status: "pending", confidence: 0 });
    }
    return `<span data-cite-id="${id}" data-status="pending">${key}</span>`;
  });
  return { html, citations };
}
DMEOF

cat > frontend/lib/html.ts <<'DMEOF'
// Small DOM helpers used by edit / delete / dictate actions (client only).
export function plainText(html: string): string {
  return html.replace(/<[^>]+>/g, " ").replace(/&nbsp;/g, " ").replace(/\s+/g, " ").trim();
}

function parse(html: string): HTMLElement {
  return new DOMParser().parseFromString(`<div id="r">${html}</div>`, "text/html").getElementById("r")!;
}

export function findPara(root: HTMLElement, n: number): Element | null {
  const ps = Array.from(root.querySelectorAll("p"));
  return ps.find((p) => new RegExp(`^\\s*${n}[.)]\\s`).test(p.textContent || "")) ?? ps[n - 1] ?? null;
}

export function removeParagraph(html: string, n: number): { html: string; removed: boolean } {
  const root = parse(html);
  const p = findPara(root, n);
  if (!p) return { html, removed: false };
  p.remove();
  return { html: root.innerHTML, removed: true };
}

export function appendParagraph(html: string, text: string): string {
  const safe = text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  return `${html}<p>${safe}</p>`;
}

export function rewriteText(html: string, dict: [RegExp, string][], n?: number): { html: string; changed: number } {
  const root = parse(html);
  const scope: Element | null = n ? findPara(root, n) : root;
  if (!scope) return { html, changed: 0 };
  const walker = scope.ownerDocument.createTreeWalker(scope, NodeFilter.SHOW_TEXT);
  let changed = 0;
  let node: Node | null;
  while ((node = walker.nextNode())) {
    let t = node.nodeValue || "";
    const before = t;
    for (const [re, rep] of dict) t = t.replace(re, rep);
    if (t !== before) { node.nodeValue = t; changed++; }
  }
  return { html: root.innerHTML, changed };
}
DMEOF

cat > frontend/lib/speech.ts <<'DMEOF'
export function speak(text: string) {
  if (typeof window === "undefined" || !("speechSynthesis" in window)) return;
  try {
    window.speechSynthesis.cancel();
    const u = new SpeechSynthesisUtterance(text);
    u.rate = 1.02; u.lang = "en-IN";
    window.speechSynthesis.speak(u);
  } catch { /* ignore */ }
}
DMEOF

cat > frontend/lib/mock.ts <<'DMEOF'
// Demo data + simulators. Lets the UI run end-to-end with NO backend.
import type { Citation, DraftEvent, RouteResult, Skill, StyleProfile } from "./types";
import { plainText, rewriteText } from "./html";

export const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

export const SKILLS: Skill[] = [
  { id: "legal_notice", name: "Legal Notice", category: "Drafting", description: "Statutory demand & legal notices with numbered paragraphs and reservation of rights.", triggers: ["legal notice", "demand notice", "notice"], example: "Draft a legal notice for non-payment of ₹5 lakh under Section 138 NI Act", requires_verification: true },
  { id: "contract_drafting", name: "Contract Drafting", category: "Drafting", description: "Commercial contracts with definitions, obligations, indemnity and dispute clauses.", triggers: ["contract", "master services"], example: "Draft a master services contract between two Indian companies", requires_verification: true },
  { id: "agreement", name: "Agreements", category: "Drafting", description: "NDA, rent, service and partnership agreements in your preferred clause style.", triggers: ["agreement", "nda", "lease", "rent"], example: "Draft a residential rent agreement for 11 months in Lucknow", requires_verification: true },
  { id: "petition", name: "Petitions & Pleadings", category: "Litigation", description: "Writ petitions, plaints and applications with facts, grounds and prayer.", triggers: ["petition", "plaint", "writ", "pleading"], example: "Draft a writ petition under Article 226 for delayed pension", requires_verification: true },
  { id: "contract_review", name: "Contract Review", category: "Review", description: "Clause-by-clause risk review with severity flags and suggested fixes.", triggers: ["review contract", "contract review", "review"], example: "Review the uploaded vendor contract and flag risky clauses", requires_verification: true },
  { id: "redlining", name: "Redlining", category: "Review", description: "Tracked-style edits that tighten language while preserving intent.", triggers: ["redline", "markup"], example: "Redline the indemnity clause to favour the buyer", requires_verification: false },
  { id: "due_diligence", name: "Due Diligence", category: "Review", description: "Checklist-driven diligence summaries with gaps and red flags.", triggers: ["due diligence", "diligence"], example: "Prepare a due-diligence checklist for a startup acquisition", requires_verification: true },
  { id: "legal_research", name: "Legal Research", category: "Research", description: "Issue-framed research memos grounded in retrievable authorities.", triggers: ["research", "memo"], example: "Research the law on presumption under Section 139 NI Act", requires_verification: true },
  { id: "case_analysis", name: "Case Analysis", category: "Research", description: "Facts, issues, holding, ratio and relevance — structured case briefs.", triggers: ["case analysis", "analyse case", "analyze case"], example: "Analyse Dashrath Rupsingh Rathod v. State of Maharashtra", requires_verification: true },
  { id: "summarisation", name: "Document Summary", category: "Research", description: "Faithful executive summaries of long judgments, contracts and orders.", triggers: ["summar"], example: "Summarise the uploaded judgment in one page", requires_verification: false },
];

export const MOCK_STYLE: StyleProfile = {
  tone: "Formal, assertive, third-person",
  structure: "Title → Parties → Subject → Numbered facts → Demand → Consequences",
  terminology: ["hereinbefore", "without prejudice", "the noticee", "at your risk as to costs"],
  clausePatterns: ["Time-bound demand (15 days)", "Reservation of rights", "Registered Post A.D. dispatch"],
  formatting: "Bold headings · numbered paragraphs · justified text",
};

const NOTICE = `# LEGAL NOTICE

**Under Section 138 of the Negotiable Instruments Act, 1881**

**By Registered Post A.D. and Email**

**To,**
M/s Rajdhani Traders Pvt. Ltd.,
Through its Director, Mr. Anil Verma,
14, Civil Lines, Lucknow, Uttar Pradesh – 226001

**Subject: Statutory demand for payment of ₹5,00,000/- (Rupees Five Lakh only) against dishonoured Cheque No. 004512.**

Sir,

Under instructions from and on behalf of my client, M/s Amethi Agro Supplies, I hereby serve upon you the following notice:

1. That my client is engaged in the business of supply of agricultural inputs and has, at your request, supplied goods worth ₹5,00,000/- vide Invoice No. AAS/2026/118 dated 12.06.2026.

2. That in discharge of the said liability, you issued Cheque No. 004512 dated 15.08.2026 for ₹5,00,000/- drawn on State Bank of India, Hazratganj Branch, Lucknow, in favour of my client.

3. That the said cheque, when presented for encashment, was returned unpaid vide Bank Memo dated 22.08.2026 with the remark "Funds Insufficient".

4. That the dishonour of the said cheque attracts the offence under [CITE: Section 138, Negotiable Instruments Act, 1881], and this notice is issued within thirty days of receipt of information regarding dishonour, as the law requires.

5. That the Hon'ble Supreme Court has dealt with territorial jurisdiction in such matters in [CITE: Dashrath Rupsingh Rathod v. State of Maharashtra, (2014) 9 SCC 129], and has laid down guidelines for summary trial in [CITE: Meters and Instruments Pvt. Ltd. v. Kanchan Mehta, (2018) 1 SCC 560].

6. That reliance is further placed on [CITE: Sharma v. Gupta Enterprises, AIR 2019 SC 4421] in support of my client's claim.

7. That you are hereby called upon to pay ₹5,00,000/- within fifteen (15) days of receipt of this notice, failing which my client shall be constrained to initiate criminal proceedings in terms of [CITE: Section 142, Negotiable Instruments Act, 1881], at your risk as to costs and consequences.

8. That you please note that this notice is issued without prejudice to my client's other rights and remedies.

Yours faithfully,

**Advocate for the Claimant**`;

const AGREEMENT = `# RESIDENTIAL RENT AGREEMENT

This Agreement is made at Lucknow on this ___ day of ________, 2026,

**BETWEEN** Mr. Rakesh Kumar (hereinafter the "Lessor") **AND** Ms. Neha Singh (hereinafter the "Lessee").

## 1. Nature of Tenancy
1. The Lessor lets the premises at 22, Gomti Nagar, Lucknow to the Lessee for residential use for a term of eleven (11) months, as a lease within the meaning of [CITE: Section 105, Transfer of Property Act, 1882].

## 2. Rent and Deposit
2. The Lessee shall pay monthly rent of ₹18,000/- on or before the 5th of each month and a refundable security deposit of ₹36,000/-.

## 3. Registration
3. The parties acknowledge that a lease exceeding twelve months requires registration under [CITE: Section 17, Registration Act, 1908]; this lease is intentionally limited to eleven months.

## 4. Termination
4. Either party may terminate this Agreement by giving thirty (30) days' written notice.

**Signed by the parties on the date first above written.**`;

const MEMO = `# LEGAL RESEARCH MEMORANDUM

**Issue:** Whether the presumption of consideration operates in favour of a holder of a dishonoured cheque.

## 1. Short Answer
Yes. Once execution of the cheque is admitted, a statutory presumption arises that the cheque was issued for a legally enforceable debt, which the accused may rebut on a preponderance of probabilities.

## 2. Analysis
1. The presumption is recognised and its standard of rebuttal explained in [CITE: Rangappa v. Sri Mohan, (2010) 11 SCC 441].

2. Procedure for summary disposal and compounding of such offences is addressed in [CITE: Meters and Instruments Pvt. Ltd. v. Kanchan Mehta, (2018) 1 SCC 560].

3. Interim compensation to the complainant may be sought under [CITE: Section 143A, Negotiable Instruments Act, 1881].

4. A further authority, [CITE: Verma Holdings v. Union of India, 2021 SCC OnLine SC 9917], is sometimes cited for a stricter standard.

## 3. Recommendation
Plead the presumption expressly, annex the bank memo, and seek interim compensation at the first hearing.`;

export function draftFor(skillId: string): string {
  if (skillId === "agreement" || skillId === "contract_drafting") return AGREEMENT;
  if (["legal_research", "case_analysis", "contract_review", "due_diligence", "summarisation", "redlining"].includes(skillId)) return MEMO;
  return NOTICE;
}

export function matchSkill(text: string): string {
  const t = text.toLowerCase();
  for (const s of SKILLS) if (s.triggers.some((k) => t.includes(k))) return s.id;
  return "legal_notice";
}

const NUM: Record<string, number> = { one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9, ten: 10 };
function paraNumber(t: string): number | undefined {
  const m = t.match(/(?:paragraph|para|clause)\s+(\d+|one|two|three|four|five|six|seven|eight|nine|ten)/i);
  if (!m) return undefined;
  const v = m[1].toLowerCase();
  return NUM[v] ?? parseInt(v, 10);
}

export function mockRoute(text: string, hasDraft: boolean): RouteResult {
  const t = text.toLowerCase().trim();
  const dict = t.match(/^(?:dictate|add paragraph|insert)\s*[:,-]?\s*(.+)$/i);
  if (dict && hasDraft) return { intent: "dictate", text: dict[1] };
  if (/\b(verify|check|validate)\b.*\b(citation|authorit|reference)/.test(t) || /^verify\b/.test(t)) return { intent: "verify" };
  if (/\b(export|download)\b|save as/.test(t)) return { intent: "export" };
  if (hasDraft && /\b(delete|remove)\b/.test(t)) return { intent: "delete", paragraph: paraNumber(t) };
  if (hasDraft && /\b(make|rewrite|rephrase|shorten|simplify|formal|polish|tone|improve|fix)\b/.test(t) && !/\b(draft|prepare|generate)\b/.test(t))
    return { intent: "edit", paragraph: paraNumber(t) };
  return { intent: "draft", skill_id: matchSkill(t) };
}

export async function mockStream(skillId: string | undefined, onEvent: (e: DraftEvent) => void, signal?: AbortSignal) {
  const id = skillId ?? "legal_notice";
  onEvent({ type: "skill", skill_id: id });
  await sleep(650);
  onEvent({ type: "usage", raw: 18420, sent: 3110 });
  await sleep(350);
  const chunks = draftFor(id).match(/\s*\S+|\s+/g) ?? [];
  for (const c of chunks) {
    if (signal?.aborted) throw new DOMException("Aborted", "AbortError");
    onEvent({ type: "token", text: c });
    await sleep(12 + Math.random() * 20);
  }
  onEvent({ type: "done" });
}

type KB = Omit<Citation, "id" | "text" | "kind">;
const IK = (q: string) => `https://indiankanoon.org/search/?formInput=${encodeURIComponent(q)}`;
const KBASE: { re: RegExp; r: KB }[] = [
  { re: /section 138/i, r: { status: "verified", confidence: 0.98, source_name: "India Code", source_url: "https://www.indiacode.nic.in/", snippet: "Dishonour of a cheque for insufficiency of funds is an offence punishable with imprisonment up to two years or a fine up to twice the cheque amount." } },
  { re: /section 142/i, r: { status: "verified", confidence: 0.94, source_name: "India Code", source_url: "https://www.indiacode.nic.in/", snippet: "Provides that cognizance is taken only on a written complaint by the payee, made within one month of the cause of action." } },
  { re: /kanchan mehta/i, r: { status: "verified", confidence: 0.96, source_name: "Indian Kanoon", source_url: IK("Meters and Instruments v. Kanchan Mehta"), snippet: "Supreme Court treats the offence as largely a civil wrong with criminal remedy and issues guidelines for summary trial and compounding." } },
  { re: /rangappa/i, r: { status: "verified", confidence: 0.95, source_name: "Indian Kanoon", source_url: IK("Rangappa v. Sri Mohan"), snippet: "Larger-bench clarification that the statutory presumption includes the existence of a legally enforceable debt." } },
  { re: /section 17.*registration|registration act/i, r: { status: "verified", confidence: 0.93, source_name: "India Code", source_url: "https://www.indiacode.nic.in/", snippet: "Leases of immovable property for a term exceeding one year require compulsory registration." } },
  { re: /section 105.*transfer of property|transfer of property act/i, r: { status: "verified", confidence: 0.95, source_name: "India Code", source_url: "https://www.indiacode.nic.in/", snippet: "Defines a lease as a transfer of the right to enjoy immovable property for a term, in consideration of rent." } },
  { re: /dashrath/i, r: { status: "partial", confidence: 0.72, source_name: "Indian Kanoon", source_url: IK("Dashrath Rupsingh Rathod v. State of Maharashtra"), snippet: "Case exists and concerns territorial jurisdiction under Section 138.", note: "Jurisdiction rule was later changed by the 2015 amendment to Section 142(2). Proposition may be outdated.", suggestion: "Cite together with Section 142(2) as amended in 2015." } },
  { re: /143a/i, r: { status: "partial", confidence: 0.68, source_name: "India Code", source_url: "https://www.indiacode.nic.in/", snippet: "Provision for interim compensation exists in the Act.", note: "Interim compensation is discretionary and applies to offences after the 2018 amendment; confirm applicability.", suggestion: "Add the cut-off date and the discretionary standard." } },
];

export async function mockVerify(citations: Citation[], onResult: (c: Citation) => void) {
  for (const c of citations) {
    await sleep(650 + Math.random() * 600);
    const hit = KBASE.find((k) => k.re.test(c.text));
    if (hit) onResult({ ...c, ...hit.r });
    else
      onResult({
        ...c, status: "unverified", confidence: 0.1, source_name: "Searched: Indian Kanoon, India Code, eCourts",
        source_url: IK(c.text),
        note: "No matching authority found in accessible sources. This does not prove it is fake, but it must not be filed unverified.",
        suggestion: "Remove it or replace it with an authority confirmed from an official reporter.",
      });
  }
}

const FORMAL: [RegExp, string][] = [
  [/\bplease note\b/gi, "kindly take note"], [/\byou please note\b/gi, "you are kindly requested to note"],
  [/\bpay\b/g, "remit"], [/\bwithin\b/g, "not later than"], [/\bask\b/g, "request"], [/\bget\b/g, "obtain"],
  [/\bso\b/g, "accordingly"], [/\babout\b/g, "regarding"], [/\bmust\b/g, "shall"], [/\bhereby called upon\b/g, "hereby called upon and required"],
];
const SIMPLE: [RegExp, string][] = [
  [/\bhereinbefore\b/g, "above"], [/\bshall\b/g, "must"], [/\bremit\b/g, "pay"], [/\bconstrained to\b/g, "forced to"], [/\bin terms of\b/g, "under"],
];

export function mockEdit(html: string, instruction: string, paragraph?: number): { html: string; summary: string } {
  const simple = /simplif|plain|shorten/i.test(instruction);
  const r = rewriteText(html, simple ? SIMPLE : FORMAL, paragraph);
  const where = paragraph ? `paragraph ${paragraph}` : "the draft";
  if (r.changed === 0) return { html, summary: `No changes needed in ${where}.` };
  return { html: r.html, summary: `Rewrote ${where} in a ${simple ? "simpler" : "more formal"} register (${r.changed} edits). Citations untouched.` };
}

export function mockUpload(file: File) {
  const tokens = Math.max(1200, Math.round(file.size / 4));
  return { id: Math.random().toString(36).slice(2, 9), name: file.name, size: file.size, status: "ready" as const, tokens, style: MOCK_STYLE };
}

export const DEMO_INSTRUCTION = "Draft a legal notice for non-payment of ₹5 lakh under Section 138 NI Act";
export const _plain = plainText;
DMEOF

cat > frontend/lib/api.ts <<'DMEOF'
// ── API LAYER ──  Single place where the UI talks to the backend.
// Every function has a LIVE branch (FastAPI) and an automatic DEMO fallback.
// Backend teammates: implement the endpoints; the UI needs no other change.
import type { Citation, DraftEvent, DraftRequest, ModelId, RouteResult, Skill, StyleProfile, UploadedDoc } from "./types";
import * as mock from "./mock";

const BASE = (process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8000").replace(/\/$/, "");
const PREF = (process.env.NEXT_PUBLIC_API_MODE ?? "auto") as "auto" | "mock" | "live";
let live = PREF === "live";

export const getMode = (): "live" | "demo" => (live ? "live" : "demo");

export async function init() {
  if (PREF === "mock") { live = false; return; }
  if (PREF === "live") { live = true; return; }
  try {
    const ctl = new AbortController();
    const t = setTimeout(() => ctl.abort(), 1500);
    const r = await fetch(`${BASE}/api/health`, { signal: ctl.signal });
    clearTimeout(t);
    live = r.ok;
  } catch { live = false; }
}

async function json<T>(path: string, init?: RequestInit): Promise<T> {
  const r = await fetch(`${BASE}${path}`, { headers: { "Content-Type": "application/json" }, ...init });
  if (!r.ok) throw new Error(`${path} → ${r.status}`);
  return r.json() as Promise<T>;
}

async function withFallback<T>(liveFn: () => Promise<T>, demoFn: () => Promise<T> | T): Promise<T> {
  if (!live) return demoFn();
  try { return await liveFn(); } catch (e) { console.warn("[api] live call failed → demo data", e); return demoFn(); }
}

// GET /api/skills → Skill[]  (or { skills: Skill[] })
export function listSkills(): Promise<Skill[]> {
  return withFallback(
    async () => { const r = await json<Skill[] | { skills: Skill[] }>("/api/skills"); return Array.isArray(r) ? r : r.skills; },
    () => mock.SKILLS,
  );
}

// POST /api/upload (multipart "file") → { id, name, size, tokens, style }
export function uploadDoc(file: File): Promise<UploadedDoc> {
  return withFallback(
    async () => {
      const fd = new FormData(); fd.append("file", file);
      const r = await fetch(`${BASE}/api/upload`, { method: "POST", body: fd });
      if (!r.ok) throw new Error("upload failed");
      const d = (await r.json()) as { id: string; name?: string; size?: number; tokens?: number; style?: StyleProfile };
      return { id: d.id, name: d.name ?? file.name, size: d.size ?? file.size, status: "ready" as const, tokens: d.tokens, style: d.style };
    },
    async () => { await mock.sleep(1300); return mock.mockUpload(file); },
  );
}

// POST /api/route { instruction, has_draft } → RouteResult
export function routeInstruction(instruction: string, hasDraft: boolean): Promise<RouteResult> {
  return withFallback(
    () => json<RouteResult>("/api/route", { method: "POST", body: JSON.stringify({ instruction, has_draft: hasDraft }) }),
    async () => { await mock.sleep(450); return mock.mockRoute(instruction, hasDraft); },
  );
}

// POST /api/draft (SSE) → DraftEvent stream
export async function streamDraft(req: DraftRequest, onEvent: (e: DraftEvent) => void, signal?: AbortSignal) {
  if (live) {
    let started = false;
    try {
      const res = await fetch(`${BASE}/api/draft`, {
        method: "POST", signal, headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ instruction: req.instruction, skill_id: req.skillId, model: req.model, doc_ids: req.docIds }),
      });
      if (!res.ok || !res.body) throw new Error("draft failed");
      const reader = res.body.getReader();
      const dec = new TextDecoder();
      let buf = "";
      for (;;) {
        const { done, value } = await reader.read();
        if (done) break;
        buf += dec.decode(value, { stream: true });
        const parts = buf.split("\n\n");
        buf = parts.pop() ?? "";
        for (const p of parts) {
          const line = p.split("\n").find((l) => l.startsWith("data:"));
          if (!line) continue;
          let ev: DraftEvent | null = null;
          try { ev = JSON.parse(line.slice(5).trim()) as DraftEvent; } catch { /* skip bad frame */ }
          if (ev) { started = true; onEvent(ev); }
        }
      }
      return;
    } catch (e) {
      if ((e as Error).name === "AbortError" || started) throw e;
      console.warn("[api] draft live failed → demo stream", e);
    }
  }
  await mock.mockStream(req.skillId, onEvent, signal);
}

// POST /api/edit { instruction, html, model, paragraph? } → { html, summary }
export function editText(p: { instruction: string; html: string; model: ModelId; paragraph?: number }): Promise<{ html: string; summary: string }> {
  return withFallback(
    () => json<{ html: string; summary: string }>("/api/edit", { method: "POST", body: JSON.stringify(p) }),
    async () => { await mock.sleep(1100); return mock.mockEdit(p.html, p.instruction, p.paragraph); },
  );
}

// POST /api/verify { citations:[{id,text,kind}] } → { citations: Citation[] }
export async function verifyCitations(cites: Citation[], onResult: (c: Citation) => void) {
  if (live) {
    try {
      const r = await json<{ citations: Citation[] }>("/api/verify", {
        method: "POST", body: JSON.stringify({ citations: cites.map(({ id, text, kind }) => ({ id, text, kind })) }),
      });
      for (const c of r.citations) { await mock.sleep(380); onResult(c); } // stagger for the reveal animation
      return;
    } catch (e) { console.warn("[api] verify live failed → demo", e); }
  }
  await mock.mockVerify(cites, onResult);
}

function download(blob: Blob, name: string) {
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob); a.download = name; a.click();
  setTimeout(() => URL.revokeObjectURL(a.href), 4000);
}

function summaryHtml(cites: Citation[]) {
  const n = (s: string) => cites.filter((c) => c.status === s).length;
  return `<hr/><p><b>Verification Summary:</b> ${n("verified")} verified · ${n("partial")} partially verified · ${n("unverified")} unverified.</p><p><i>Generated with DraftMate Studio. Requires review by a qualified advocate before use.</i></p>`;
}

// POST /api/export?fmt=docx|pdf { title, html, citations } → file blob
export async function exportDoc(fmt: "docx" | "pdf", p: { title: string; html: string; citations: Citation[] }) {
  const slug = (p.title || "draft").toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "") || "draft";
  if (live) {
    try {
      const r = await fetch(`${BASE}/api/export?fmt=${fmt}`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(p) });
      if (!r.ok) throw new Error("export failed");
      download(await r.blob(), `${slug}.${fmt}`);
      return;
    } catch (e) { console.warn("[api] export live failed → local export", e); }
  }
  const body = `<html><head><meta charset="utf-8"><title>${p.title}</title><style>body{font-family:'Times New Roman',serif;line-height:1.7;max-width:760px;margin:40px auto}h1{text-align:center}p{text-align:justify}</style></head><body>${p.html}${summaryHtml(p.citations)}</body></html>`;
  if (fmt === "pdf") {
    const w = window.open("", "_blank");
    if (w) { w.document.write(body); w.document.close(); setTimeout(() => w.print(), 400); }
    return;
  }
  download(new Blob(["\ufeff", body], { type: "application/msword" }), `${slug}.doc`);
}
DMEOF

cat > frontend/lib/store.ts <<'DMEOF'
"use client";
import { create } from "zustand";
import type { ActivityItem, Citation, ConfirmRequest, ModelId, Skill, TokenStats, UploadedDoc, VoiceState } from "./types";

export type Phase = "idle" | "routing" | "drafting" | "verifying" | "editing" | "done";
export type DocSource = "stream" | "user" | "external";

const uid = () => Math.random().toString(36).slice(2, 9);

interface State {
  skills: Skill[];
  skillsLoading: boolean;
  activeSkillId: string | null;
  model: ModelId;
  docs: UploadedDoc[];
  doc: { html: string; rev: number; source: DocSource };
  title: string;
  rawDraft: string;
  streaming: boolean;
  phase: Phase;
  citations: Citation[];
  activeCitationId: string | null;
  tokens: TokenStats | null;
  activity: ActivityItem[];
  voice: { state: VoiceState; transcript: string };
  confirm: ConfirmRequest | null;
  commandDraft: string;
  mobileTab: "skills" | "draft" | "review";
  mode: "live" | "demo";
  flashKey: number;
  checklist: { id: string; label: string; done: boolean }[];

  patch: (p: Partial<State>) => void;
  setDoc: (html: string, source: DocSource) => void;
  setUserHtml: (html: string) => void;
  addActivity: (label: string, state?: ActivityItem["state"]) => string;
  updateActivity: (id: string, p: Partial<ActivityItem>) => void;
  updateCitation: (c: Citation) => void;
  toggleCheck: (id: string) => void;
}

export const useStore = create<State>()((set) => ({
  skills: [],
  skillsLoading: true,
  activeSkillId: null,
  model: "claude",
  docs: [],
  doc: { html: "", rev: 0, source: "external" },
  title: "Untitled draft",
  rawDraft: "",
  streaming: false,
  phase: "idle",
  citations: [],
  activeCitationId: null,
  tokens: null,
  activity: [],
  voice: { state: "idle", transcript: "" },
  confirm: null,
  commandDraft: "",
  mobileTab: "draft",
  mode: "demo",
  flashKey: 0,
  checklist: [
    { id: "parties", label: "Party names, dates & amounts confirmed", done: false },
    { id: "cites", label: "Every flagged citation checked at source", done: false },
    { id: "facts", label: "Facts match client instructions", done: false },
    { id: "signoff", label: "Reviewed by a qualified advocate", done: false },
  ],

  patch: (p) => set(p),
  setDoc: (html, source) => set((s) => ({ doc: { html, source, rev: s.doc.rev + 1 } })),
  setUserHtml: (html) => set((s) => ({ doc: { html, source: "user", rev: s.doc.rev } })),
  addActivity: (label, state = "running") => {
    const id = uid();
    set((s) => ({ activity: [...s.activity, { id, label, state, ts: Date.now() }].slice(-6) }));
    return id;
  },
  updateActivity: (id, p) => set((s) => ({ activity: s.activity.map((a) => (a.id === id ? { ...a, ...p, ts: Date.now() } : a)) })),
  updateCitation: (c) => set((s) => ({ citations: s.citations.map((x) => (x.id === c.id ? { ...x, ...c } : x)) })),
  toggleCheck: (id) => set((s) => ({ checklist: s.checklist.map((c) => (c.id === id ? { ...c, done: !c.done } : c)) })),
}));
DMEOF

cat > frontend/lib/actions.ts <<'DMEOF'
// ── ORCHESTRATION ──  All user-facing workflows live here (UI stays dumb).
// Voice (Member 4) and the text command bar both call runInstruction().
import * as api from "./api";
import { buildHtml } from "./citations";
import { DEMO_INSTRUCTION } from "./mock";
import { appendParagraph, plainText, removeParagraph } from "./html";
import { speak } from "./speech";
import { useStore } from "./store";
import type { ConfirmRequest } from "./types";

const S = () => useStore.getState();
let abortCtl: AbortController | null = null;

const trunc = (s: string, n: number) => (s.length > n ? s.slice(0, n - 1) + "…" : s);
const hasDraft = () => plainText(S().doc.html).length > 0;
const skillName = (id?: string | null) => S().skills.find((s) => s.id === id)?.name ?? "Legal skill";

function titleFrom(raw: string) {
  const m = raw.match(/^#\s+(.+)$/m);
  if (!m) return "Untitled draft";
  return m[1].toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase());
}

export async function bootstrap() {
  await api.init();
  S().patch({ mode: api.getMode() });
  const skills = await api.listSkills();
  S().patch({ skills, skillsLoading: false });
}

export function requestConfirm(req: ConfirmRequest) {
  S().patch({ confirm: req });
  if (S().voice.state !== "idle") speak(`${req.title}. ${req.message} Say confirm or cancel.`);
}

export function resolveConfirm(accept: boolean) {
  const c = S().confirm;
  S().patch({ confirm: null });
  if (accept && c) c.onConfirm();
}

export function stopGeneration() { abortCtl?.abort(); }

export async function runInstruction(raw: string) {
  const text = raw.trim();
  if (!text) return;
  const s = S();
  if (["routing", "drafting", "editing"].includes(s.phase)) return;

  const act = s.addActivity(`Understood: “${trunc(text, 46)}”`);
  S().patch({ phase: "routing" });
  let route;
  try { route = await api.routeInstruction(text, hasDraft()); } catch { route = { intent: "draft" as const }; }
  S().updateActivity(act, { state: "done" });
  S().patch({ phase: hasDraft() ? "done" : "idle" });

  switch (route.intent) {
    case "verify": return runVerify();
    case "export": return exportDoc("docx");
    case "dictate": return dictate(route.text ?? text);
    case "edit": return runEdit(text, route.paragraph);
    case "delete":
      return requestConfirm({
        title: route.paragraph ? `Delete paragraph ${route.paragraph}?` : "Delete the entire draft?",
        message: "This changes your document. You can’t undo a delete from voice.",
        confirmLabel: "Delete", danger: true,
        onConfirm: () => doDelete(route.paragraph),
      });
    default:
      if (hasDraft())
        return requestConfirm({
          title: "Replace the current draft?",
          message: "A new draft will overwrite what is in the workspace.",
          confirmLabel: "Overwrite", danger: true,
          onConfirm: () => runDraft(text, route.skill_id),
        });
      return runDraft(text, route.skill_id);
  }
}

export async function runDraft(text: string, skillArg?: string) {
  const skillId = skillArg ?? S().activeSkillId ?? undefined;
  S().patch({ phase: "drafting", streaming: true, rawDraft: "", citations: [], activeCitationId: null, tokens: null, mobileTab: "draft" });
  S().setDoc("", "external");
  const act = S().addActivity("Retrieving context & style profile");
  abortCtl = new AbortController();
  let raw = "";
  let last = 0;
  const paint = (force = false) => {
    const now = performance.now();
    if (!force && now - last < 60) return;
    last = now;
    S().setDoc(buildHtml(raw).html, "stream");
  };
  try {
    await api.streamDraft(
      { instruction: text, skillId, model: S().model, docIds: S().docs.filter((d) => d.status === "ready").map((d) => d.id) },
      (ev) => {
        if (ev.type === "skill") { S().patch({ activeSkillId: ev.skill_id }); S().updateActivity(act, { label: `Skill: ${skillName(ev.skill_id)} · drafting` }); }
        else if (ev.type === "token") { raw += ev.text; paint(); }
        else if (ev.type === "usage") S().patch({ tokens: { raw: ev.raw, sent: ev.sent } });
        else if (ev.type === "error") throw new Error(ev.message);
      },
      abortCtl.signal,
    );
    const built = buildHtml(raw);
    S().patch({ rawDraft: raw, citations: built.citations, streaming: false, phase: "done", title: titleFrom(raw) });
    S().setDoc(built.html, "stream");
    S().updateActivity(act, { label: "Draft ready", state: "done" });
    if (built.citations.length) await runVerify();
  } catch (e) {
    const aborted = (e as Error).name === "AbortError";
    S().patch({ streaming: false, phase: hasDraft() ? "done" : "idle" });
    S().updateActivity(act, { label: aborted ? "Stopped" : `Draft failed: ${(e as Error).message}`, state: aborted ? "done" : "error" });
  }
}

export async function runVerify() {
  const cites = S().citations;
  if (!cites.length) { S().addActivity("No citations found in this draft", "done"); return; }
  S().patch({ phase: "verifying", mobileTab: S().mobileTab });
  cites.forEach((c) => S().updateCitation({ ...c, status: "pending" }));
  const act = S().addActivity(`Verifying ${cites.length} citations against legal sources`);
  try {
    await api.verifyCitations(cites, (c) => S().updateCitation(c));
    const f = S().citations;
    const n = (st: string) => f.filter((c) => c.status === st).length;
    S().updateActivity(act, { label: `${n("verified")} verified · ${n("partial")} partial · ${n("unverified")} unverified`, state: "done" });
  } catch (e) {
    S().updateActivity(act, { label: `Verification failed: ${(e as Error).message}`, state: "error" });
  }
  S().patch({ phase: "done" });
}

export async function runEdit(text: string, paragraph?: number) {
  S().patch({ phase: "editing" });
  const act = S().addActivity("Applying edit");
  try {
    const r = await api.editText({ instruction: text, html: S().doc.html, model: S().model, paragraph });
    S().setDoc(r.html, "external");
    S().patch({ flashKey: S().flashKey + 1 });
    S().updateActivity(act, { label: r.summary, state: "done" });
  } catch (e) {
    S().updateActivity(act, { label: `Edit failed: ${(e as Error).message}`, state: "error" });
  }
  S().patch({ phase: "done" });
}

function dictate(text: string) {
  S().setDoc(appendParagraph(S().doc.html, text), "external");
  S().patch({ flashKey: S().flashKey + 1 });
  S().addActivity("Dictated paragraph added", "done");
}

function doDelete(paragraph?: number) {
  if (!paragraph) {
    S().setDoc("", "external");
    S().patch({ citations: [], tokens: null, phase: "idle", rawDraft: "", title: "Untitled draft" });
    S().addActivity("Draft deleted", "done");
    return;
  }
  const r = removeParagraph(S().doc.html, paragraph);
  if (r.removed) { S().setDoc(r.html, "external"); S().patch({ flashKey: S().flashKey + 1 }); }
  S().addActivity(r.removed ? `Paragraph ${paragraph} deleted` : `Couldn’t find paragraph ${paragraph}`, r.removed ? "done" : "error");
}

export async function exportDoc(fmt: "docx" | "pdf") {
  if (!hasDraft()) { S().addActivity("Nothing to export yet", "error"); return; }
  const act = S().addActivity(`Exporting ${fmt.toUpperCase()}`);
  try {
    await api.exportDoc(fmt, { title: S().title, html: S().doc.html, citations: S().citations });
    S().updateActivity(act, { label: `${fmt.toUpperCase()} exported with verification summary`, state: "done" });
  } catch (e) {
    S().updateActivity(act, { label: `Export failed: ${(e as Error).message}`, state: "error" });
  }
}

export async function uploadFiles(files: File[]) {
  for (const f of files) {
    const tempId = `tmp-${Math.random().toString(36).slice(2, 8)}`;
    S().patch({ docs: [...S().docs, { id: tempId, name: f.name, size: f.size, status: "processing" }] });
    const act = S().addActivity(`Converting ${trunc(f.name, 26)} to Markdown`);
    try {
      const d = await api.uploadDoc(f);
      S().patch({ docs: S().docs.map((x) => (x.id === tempId ? d : x)) });
      S().updateActivity(act, { label: `Style profile learned from ${trunc(f.name, 22)}`, state: "done" });
    } catch {
      S().patch({ docs: S().docs.map((x) => (x.id === tempId ? { ...x, status: "error" as const } : x)) });
      S().updateActivity(act, { label: `Couldn’t process ${trunc(f.name, 22)}`, state: "error" });
    }
  }
}

export async function runDemo() {
  await uploadFiles([new File(["demo reference"], "Sample_Reference_Notice.docx", { type: "application/octet-stream" })]);
  await runInstruction(DEMO_INSTRUCTION);
}
DMEOF

cat > frontend/lib/voice.ts <<'DMEOF'
"use client";
// ── VOICE HOOK ──  Web Speech API (Chrome). Member 4 can extend / swap for Whisper.
import { useCallback, useEffect, useRef, useState } from "react";
import { resolveConfirm, runInstruction } from "./actions";
import { useStore } from "./store";

/* eslint-disable @typescript-eslint/no-explicit-any */
export function useVoice() {
  const recRef = useRef<any>(null);
  const [supported, setSupported] = useState(true);
  const state = useStore((s) => s.voice.state);
  const transcript = useStore((s) => s.voice.transcript);

  useEffect(() => {
    const SR = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
    if (!SR) { setSupported(false); return; }
    const rec = new SR();
    rec.lang = "en-IN";
    rec.interimResults = true;
    rec.continuous = false;
    const patch = useStore.getState().patch;

    rec.onstart = () => patch({ voice: { state: "listening", transcript: "" } });
    rec.onresult = (e: any) => {
      let t = "";
      let final = false;
      for (let i = e.resultIndex; i < e.results.length; i++) {
        t += e.results[i][0].transcript;
        if (e.results[i].isFinal) final = true;
      }
      patch({ voice: { state: final ? "processing" : "listening", transcript: t } });
      if (final) handleFinal(t.trim());
    };
    rec.onerror = () => {
      patch({ voice: { state: "error", transcript: "Mic unavailable or permission denied" } });
      setTimeout(() => patch({ voice: { state: "idle", transcript: "" } }), 2200);
    };
    rec.onend = () => {
      if (useStore.getState().voice.state === "listening") patch({ voice: { state: "idle", transcript: "" } });
    };
    recRef.current = rec;
    return () => { try { rec.abort(); } catch { /* noop */ } };
  }, []);

  const toggle = useCallback(() => {
    const rec = recRef.current;
    if (!rec) return;
    if (useStore.getState().voice.state === "listening") rec.stop();
    else { try { rec.start(); } catch { /* already started */ } }
  }, []);

  return { supported, state, transcript, toggle };
}

async function handleFinal(text: string) {
  const patch = useStore.getState().patch;
  const done = () => setTimeout(() => patch({ voice: { state: "idle", transcript: "" } }), 1400);
  if (useStore.getState().confirm) {
    if (/\b(confirm|yes|proceed|go ahead|do it)\b/i.test(text)) resolveConfirm(true);
    else if (/\b(cancel|no|stop|don'?t)\b/i.test(text)) resolveConfirm(false);
    done();
    return;
  }
  await runInstruction(text);
  done();
}
DMEOF

# ───────────────────────────── COMPONENTS ─────────────────────────────
cat > frontend/components/ThemeProvider.tsx <<'DMEOF'
"use client";
import { ThemeProvider as NextThemes } from "next-themes";
import type { ComponentProps } from "react";

export function ThemeProvider(props: ComponentProps<typeof NextThemes>) {
  return <NextThemes {...props} />;
}
DMEOF

cat > frontend/components/ThemeToggle.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { Moon, Sun } from "lucide-react";
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";

export function ThemeToggle() {
  const { resolvedTheme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);
  const dark = mounted ? resolvedTheme === "dark" : true;
  return (
    <button aria-label="Toggle theme" className="btn-icon overflow-hidden" onClick={() => setTheme(dark ? "light" : "dark")}>
      <AnimatePresence mode="wait" initial={false}>
        <motion.span key={dark ? "d" : "l"} initial={{ y: -14, opacity: 0, rotate: -70 }} animate={{ y: 0, opacity: 1, rotate: 0 }} exit={{ y: 14, opacity: 0, rotate: 70 }} transition={{ duration: 0.2 }}>
          {dark ? <Moon size={16} /> : <Sun size={16} />}
        </motion.span>
      </AnimatePresence>
    </button>
  );
}
DMEOF

cat > frontend/components/Logo.tsx <<'DMEOF'
"use client";
import { motion } from "framer-motion";

export function Logo({ size = 32 }: { size?: number }) {
  return (
    <motion.svg viewBox="0 0 64 64" width={size} height={size} fill="none" stroke="currentColor" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round" className="text-accent">
      <motion.path d="M32 8v44" initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.9 }} />
      <motion.path d="M20 54h24" initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.9, delay: 0.3 }} />
      <motion.g style={{ transformOrigin: "32px 16px" }} animate={{ rotate: [-3, 3, -3] }} transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}>
        <motion.path d="M10 16h44" initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 0.9, delay: 0.2 }} />
        <motion.path d="M10 16 4 34h12z" initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 1, delay: 0.5 }} />
        <motion.path d="M54 16l-6 18h12z" initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 1, delay: 0.5 }} />
      </motion.g>
      <circle cx="32" cy="8" r="2.5" fill="currentColor" />
    </motion.svg>
  );
}
DMEOF

cat > frontend/components/Splash.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { useEffect, useState } from "react";
import { Logo } from "./Logo";

export function Splash() {
  const [show, setShow] = useState(false);
  useEffect(() => {
    try {
      if (sessionStorage.getItem("dm-splash")) return;
      sessionStorage.setItem("dm-splash", "1");
    } catch { /* ignore */ }
    setShow(true);
    const t = setTimeout(() => setShow(false), 2300);
    return () => clearTimeout(t);
  }, []);
  return (
    <AnimatePresence>
      {show && (
        <motion.div key="splash" className="fixed inset-0 z-[100] flex flex-col items-center justify-center bg-bg" exit={{ opacity: 0, scale: 1.04 }} transition={{ duration: 0.6 }}>
          <Logo size={92} />
          <div className="mt-6 flex overflow-hidden font-display text-4xl font-semibold tracking-wide">
            {"DraftMate Studio".split("").map((ch, i) => (
              <motion.span key={i} initial={{ y: 40, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ delay: 0.5 + i * 0.035, duration: 0.45 }}>
                {ch === " " ? "\u00A0" : ch}
              </motion.span>
            ))}
          </div>
          <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1.3 }} className="mt-3 text-sm text-muted">
            Draft in your style · Verify every authority · Command by voice
          </motion.p>
          <div className="mt-8 h-[3px] w-56 overflow-hidden rounded-full bg-line/60">
            <motion.div className="h-full rounded-full bg-accent" initial={{ width: "0%" }} animate={{ width: "100%" }} transition={{ duration: 2, ease: "easeInOut" }} />
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
DMEOF

cat > frontend/components/AnimatedBackground.tsx <<'DMEOF'
export function AnimatedBackground() {
  return (
    <div aria-hidden className="pointer-events-none fixed inset-0 -z-10 overflow-hidden">
      <div className="blob -left-24 -top-24 h-[420px] w-[420px] bg-gold-500/60" />
      <div className="blob right-[-120px] top-1/4 h-[480px] w-[480px] bg-sky-500/40" style={{ animationDelay: "-8s" }} />
      <div className="blob bottom-[-160px] left-1/3 h-[460px] w-[460px] bg-violet-500/40" style={{ animationDelay: "-15s" }} />
      <div className="bg-grid absolute inset-0" />
    </div>
  );
}
DMEOF

cat > frontend/components/SkillIcon.tsx <<'DMEOF'
import { AlignLeft, FileSignature, Gavel, GitCompare, Handshake, Library, Scale, ScrollText, SearchCheck, ShieldCheck, Sparkles } from "lucide-react";

const MAP = {
  legal_notice: ScrollText, contract_drafting: FileSignature, agreement: Handshake, petition: Gavel,
  contract_review: ShieldCheck, redlining: GitCompare, due_diligence: SearchCheck,
  legal_research: Library, case_analysis: Scale, summarisation: AlignLeft,
} as const;

export function SkillIcon({ id, size = 18 }: { id: string; size?: number }) {
  const Icon = (MAP as Record<string, typeof Sparkles>)[id] ?? Sparkles;
  return <Icon size={size} />;
}
DMEOF

cat > frontend/components/ModelSelector.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { Check, ChevronDown, Cpu } from "lucide-react";
import { useState } from "react";
import { useStore } from "@/lib/store";
import type { ModelId } from "@/lib/types";

const MODELS: { id: ModelId; name: string; hint: string; dot: string }[] = [
  { id: "claude", name: "Claude", hint: "Careful legal reasoning", dot: "bg-orange-400" },
  { id: "gpt", name: "GPT", hint: "Fast general drafting", dot: "bg-emerald-400" },
  { id: "gemini", name: "Gemini", hint: "Long-context documents", dot: "bg-sky-400" },
];

export function ModelSelector() {
  const model = useStore((s) => s.model);
  const patch = useStore((s) => s.patch);
  const [open, setOpen] = useState(false);
  const cur = MODELS.find((m) => m.id === model)!;
  return (
    <div className="relative">
      <button className="btn" onClick={() => setOpen((o) => !o)} aria-haspopup="listbox" aria-expanded={open}>
        <Cpu size={15} className="text-accent" />
        <span className={`h-2 w-2 rounded-full ${cur.dot}`} />
        <span className="hidden sm:inline">{cur.name}</span>
        <ChevronDown size={14} className={`transition ${open ? "rotate-180" : ""}`} />
      </button>
      <AnimatePresence>
        {open && (
          <>
            <div className="fixed inset-0 z-30" onClick={() => setOpen(false)} />
            <motion.ul initial={{ opacity: 0, y: -6, scale: 0.97 }} animate={{ opacity: 1, y: 0, scale: 1 }} exit={{ opacity: 0, y: -6, scale: 0.97 }} transition={{ duration: 0.14 }} className="glass absolute right-0 z-40 mt-2 w-60 rounded-xl p-1.5" role="listbox">
              {MODELS.map((m) => (
                <li key={m.id}>
                  <button onClick={() => { patch({ model: m.id }); setOpen(false); }} className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-left hover:bg-accent/10">
                    <span className={`h-2.5 w-2.5 rounded-full ${m.dot}`} />
                    <span className="flex-1">
                      <span className="block text-sm font-medium">{m.name}</span>
                      <span className="block text-xs text-muted">{m.hint}</span>
                    </span>
                    {m.id === model && <Check size={15} className="text-accent" />}
                  </button>
                </li>
              ))}
            </motion.ul>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}
DMEOF

cat > frontend/components/layout/TopBar.tsx <<'DMEOF'
"use client";
import { motion } from "framer-motion";
import { ChevronDown, Download, FileText } from "lucide-react";
import { useState } from "react";
import { exportDoc } from "@/lib/actions";
import { plainText } from "@/lib/html";
import { useStore, type Phase } from "@/lib/store";
import { Logo } from "../Logo";
import { ModelSelector } from "../ModelSelector";
import { ThemeToggle } from "../ThemeToggle";

const PHASE: Record<Phase, string> = {
  idle: "Ready", routing: "Understanding", drafting: "Drafting", verifying: "Verifying citations", editing: "Editing", done: "Review ready",
};

export function TopBar() {
  const title = useStore((s) => s.title);
  const patch = useStore((s) => s.patch);
  const phase = useStore((s) => s.phase);
  const mode = useStore((s) => s.mode);
  const hasDoc = useStore((s) => plainText(s.doc.html).length > 0);
  const [menu, setMenu] = useState(false);
  const busy = phase !== "idle" && phase !== "done";

  return (
    <header className="glass relative z-20 mx-3 mt-3 flex items-center gap-3 rounded-2xl px-4 py-2.5">
      <div className="flex items-center gap-2.5">
        <Logo size={30} />
        <div className="leading-tight">
          <div className="font-display text-lg font-semibold tracking-wide">DraftMate <span className="text-accent">Studio</span></div>
          <div className="hidden text-[10px] uppercase tracking-[0.2em] text-muted sm:block">Legal drafting · verification · voice</div>
        </div>
      </div>

      <div className="mx-auto hidden min-w-0 max-w-md flex-1 items-center gap-2 md:flex">
        <FileText size={15} className="shrink-0 text-muted" />
        <input value={title} onChange={(e) => patch({ title: e.target.value })} aria-label="Document title" className="w-full truncate rounded-md bg-transparent px-1.5 py-1 text-sm font-medium outline-none ring-accent/40 focus:ring-2" />
      </div>

      <div className="ml-auto flex items-center gap-2">
        <span className="chip hidden sm:inline-flex">
          <motion.span className={`h-2 w-2 rounded-full ${busy ? "bg-accent" : "bg-emerald-400"}`} animate={busy ? { opacity: [1, 0.3, 1] } : {}} transition={{ repeat: Infinity, duration: 1 }} />
          {PHASE[phase]}
        </span>
        <span className={`chip hidden lg:inline-flex ${mode === "live" ? "!border-emerald-500/40 !text-emerald-400" : ""}`} title={mode === "live" ? "Connected to backend" : "Backend not detected — using built-in demo data"}>
          {mode === "live" ? "Live backend" : "Demo mode"}
        </span>
        <ModelSelector />
        <div className="relative">
          <button className="btn-gold" disabled={!hasDoc} onClick={() => setMenu((m) => !m)}>
            <Download size={15} /> <span className="hidden sm:inline">Export</span> <ChevronDown size={13} />
          </button>
          {menu && (
            <>
              <div className="fixed inset-0 z-30" onClick={() => setMenu(false)} />
              <motion.div initial={{ opacity: 0, y: -6 }} animate={{ opacity: 1, y: 0 }} className="glass absolute right-0 z-40 mt-2 w-44 rounded-xl p-1.5">
                {(["docx", "pdf"] as const).map((f) => (
                  <button key={f} className="w-full rounded-lg px-3 py-2 text-left text-sm hover:bg-accent/10" onClick={() => { setMenu(false); exportDoc(f); }}>
                    {f === "docx" ? "Word (.docx)" : "PDF (print)"}
                  </button>
                ))}
              </motion.div>
            </>
          )}
        </div>
        <ThemeToggle />
      </div>
    </header>
  );
}
DMEOF

cat > frontend/components/UploadZone.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { Check, ChevronDown, FileText, Loader2, Sparkles, UploadCloud } from "lucide-react";
import { useRef, useState } from "react";
import { uploadFiles } from "@/lib/actions";
import { useStore } from "@/lib/store";

export function UploadZone() {
  const docs = useStore((s) => s.docs);
  const [drag, setDrag] = useState(false);
  const [open, setOpen] = useState<string | null>(null);
  const input = useRef<HTMLInputElement>(null);
  const take = (files: FileList | null) => { if (files?.length) uploadFiles(Array.from(files)); };

  return (
    <div>
      <div className="mb-2 flex items-center justify-between">
        <span className="label">Reference materials</span>
        <span className="chip">{docs.length} files</span>
      </div>
      <motion.div
        onDragOver={(e) => { e.preventDefault(); setDrag(true); }} onDragLeave={() => setDrag(false)}
        onDrop={(e) => { e.preventDefault(); setDrag(false); take(e.dataTransfer.files); }}
        onClick={() => input.current?.click()} animate={{ scale: drag ? 1.02 : 1 }}
        className={`group relative cursor-pointer overflow-hidden rounded-xl border border-dashed p-4 text-center transition ${drag ? "border-accent bg-accent/10" : "border-line hover:border-accent/60"}`}
      >
        <input ref={input} type="file" multiple hidden accept=".pdf,.docx,.doc,.txt,.md,.pptx" onChange={(e) => take(e.target.files)} />
        <motion.div animate={{ y: drag ? -3 : 0 }}><UploadCloud className="mx-auto mb-1 text-accent" size={22} /></motion.div>
        <p className="text-sm font-medium">Drop templates or past drafts</p>
        <p className="text-[11px] text-muted">PDF · DOCX · TXT · PPTX → Markdown</p>
      </motion.div>

      <ul className="mt-2 space-y-1.5">
        <AnimatePresence initial={false}>
          {docs.map((d) => (
            <motion.li key={d.id} layout initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, height: 0 }} className="rounded-xl border border-line/70 bg-panel/50 px-3 py-2">
              <button className="flex w-full items-center gap-2 text-left" onClick={() => d.style && setOpen(open === d.id ? null : d.id)}>
                <FileText size={15} className="shrink-0 text-accent" />
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-[13px] font-medium">{d.name}</span>
                  <span className="block text-[11px] text-muted">
                    {d.status === "processing" ? "Converting → Markdown · learning style…" : d.status === "error" ? "Failed" : `${(d.tokens ?? 0).toLocaleString()} tokens · style learned`}
                  </span>
                </span>
                {d.status === "processing" && <Loader2 size={15} className="animate-spin text-accent" />}
                {d.status === "ready" && <><Check size={15} className="text-emerald-400" /><ChevronDown size={14} className={`text-muted transition ${open === d.id ? "rotate-180" : ""}`} /></>}
              </button>
              <AnimatePresence>
                {open === d.id && d.style && (
                  <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden">
                    <div className="mt-2 space-y-2 border-t border-line/60 pt-2 text-[11.5px]">
                      <div className="flex items-center gap-1.5 font-semibold text-accent"><Sparkles size={12} /> Learned style profile</div>
                      <p><span className="text-muted">Tone · </span>{d.style.tone}</p>
                      <p><span className="text-muted">Structure · </span>{d.style.structure}</p>
                      <div className="flex flex-wrap gap-1">{d.style.terminology.map((t) => <span key={t} className="chip">{t}</span>)}</div>
                      <div className="flex flex-wrap gap-1">{d.style.clausePatterns.map((t) => <span key={t} className="chip !border-accent/40 !text-accent">{t}</span>)}</div>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.li>
          ))}
        </AnimatePresence>
      </ul>
    </div>
  );
}
DMEOF

cat > frontend/components/SkillLibrary.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { Check, Search, ShieldCheck } from "lucide-react";
import { useMemo, useState } from "react";
import { useStore } from "@/lib/store";
import { SkillIcon } from "./SkillIcon";

export function SkillLibrary() {
  const skills = useStore((s) => s.skills);
  const loading = useStore((s) => s.skillsLoading);
  const active = useStore((s) => s.activeSkillId);
  const patch = useStore((s) => s.patch);
  const [q, setQ] = useState("");
  const [cat, setCat] = useState("All");

  const cats = useMemo(() => ["All", ...Array.from(new Set(skills.map((s) => s.category)))], [skills]);
  const list = skills.filter((s) => (cat === "All" || s.category === cat) && (s.name + s.description).toLowerCase().includes(q.toLowerCase()));

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <div className="mb-2 flex items-center justify-between">
        <span className="label">Legal skills</span>
        <span className="chip">{skills.length} loaded</span>
      </div>
      <div className="relative mb-2">
        <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted" />
        <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search skills…" className="w-full rounded-xl border border-line/70 bg-panel/50 py-2 pl-8 pr-3 text-sm outline-none transition focus:border-accent/60" />
      </div>
      <div className="scroll-thin -mx-1 mb-2 flex gap-1.5 overflow-x-auto px-1 pb-1">
        {cats.map((c) => (
          <button key={c} onClick={() => setCat(c)} className={`relative shrink-0 rounded-full px-3 py-1 text-xs font-medium transition ${cat === c ? "text-ink-950" : "text-muted hover:text-fg"}`}>
            {cat === c && <motion.span layoutId="cat-pill" className="absolute inset-0 rounded-full bg-gradient-to-br from-gold-300 to-gold-500" />}
            <span className="relative">{c}</span>
          </button>
        ))}
      </div>

      <div className="scroll-thin -mr-1 min-h-0 flex-1 space-y-2 overflow-y-auto pr-1">
        {loading && Array.from({ length: 4 }).map((_, i) => <div key={i} className="shimmer h-[76px] rounded-xl border border-line/60" />)}
        <AnimatePresence initial={false}>
          {list.map((s) => {
            const on = active === s.id;
            return (
              <motion.button
                key={s.id} layout initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, scale: 0.96 }} whileHover={{ y: -2 }} whileTap={{ scale: 0.985 }}
                onClick={() => patch({ activeSkillId: on ? null : s.id, commandDraft: on ? "" : s.example ?? "" })}
                className={`relative block w-full overflow-hidden rounded-xl border p-3 text-left transition ${on ? "border-accent bg-accent/10 shadow-[0_0_0_1px_rgb(var(--accent)/.4),0_12px_30px_-12px_rgb(var(--accent)/.5)]" : "border-line/70 bg-panel/50 hover:border-accent/50"}`}
              >
                <div className="flex items-start gap-3">
                  <div className={`flex h-9 w-9 shrink-0 items-center justify-center rounded-lg ${on ? "bg-gradient-to-br from-gold-300 to-gold-500 text-ink-950" : "bg-accent/10 text-accent"}`}>
                    <SkillIcon id={s.id} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-1.5">
                      <span className="truncate text-sm font-semibold">{s.name}</span>
                      {s.requires_verification && <ShieldCheck size={13} className="shrink-0 text-emerald-400" aria-label="Verifies citations" />}
                    </div>
                    <p className="line-clamp-2 text-[11.5px] leading-snug text-muted">{s.description}</p>
                  </div>
                  {on && <Check size={16} className="mt-0.5 shrink-0 text-accent" />}
                </div>
              </motion.button>
            );
          })}
        </AnimatePresence>
        {!loading && list.length === 0 && <p className="py-6 text-center text-sm text-muted">No skills match “{q}”.</p>}
      </div>
    </div>
  );
}
DMEOF

cat > frontend/components/layout/LeftPane.tsx <<'DMEOF'
import { SkillLibrary } from "../SkillLibrary";
import { UploadZone } from "../UploadZone";

export function LeftPane() {
  return (
    <aside className="glass flex h-full min-h-0 w-full flex-col gap-4 overflow-hidden rounded-2xl p-3.5">
      <div className="max-h-[42%] shrink-0 overflow-y-auto scroll-thin pr-1"><UploadZone /></div>
      <SkillLibrary />
    </aside>
  );
}
DMEOF

cat > frontend/components/EmptyState.tsx <<'DMEOF'
"use client";
import { motion } from "framer-motion";
import { FileUp, Mic, Play, ShieldCheck, Sparkles } from "lucide-react";
import { useEffect, useState } from "react";
import { runDemo } from "@/lib/actions";
import { useStore } from "@/lib/store";
import { Logo } from "./Logo";
import { SkillIcon } from "./SkillIcon";

const LINES = [
  "Draft a legal notice for non-payment of ₹5 lakh…",
  "Review this vendor contract and flag risky clauses…",
  "Research the presumption under Section 139 NI Act…",
  "Verify all citations in my petition…",
  "Make paragraph 3 more formal…",
];

function useTypewriter(lines: string[]) {
  const [i, setI] = useState(0);
  const [n, setN] = useState(0);
  const [del, setDel] = useState(false);
  useEffect(() => {
    const full = lines[i];
    let delay = del ? 14 : 34;
    if (!del && n === full.length) delay = 1500;
    const t = setTimeout(() => {
      if (!del && n === full.length) setDel(true);
      else if (del && n === 0) { setDel(false); setI((i + 1) % lines.length); }
      else setN(n + (del ? -1 : 1));
    }, delay);
    return () => clearTimeout(t);
  }, [n, del, i, lines]);
  return lines[i].slice(0, n);
}

export function EmptyState({ onBlank }: { onBlank: () => void }) {
  const text = useTypewriter(LINES);
  const skills = useStore((s) => s.skills).slice(0, 4);
  const patch = useStore((s) => s.patch);

  return (
    <motion.div initial={{ opacity: 0, y: 14 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -10 }} className="flex h-full flex-col items-center justify-center px-6 py-8 text-center">
      <motion.div animate={{ y: [0, -6, 0] }} transition={{ repeat: Infinity, duration: 5, ease: "easeInOut" }}><Logo size={64} /></motion.div>
      <h1 className="mt-4 font-display text-4xl font-semibold leading-tight sm:text-5xl">
        What shall we <span className="bg-gradient-to-r from-gold-300 via-gold-500 to-gold-300 bg-clip-text text-transparent">draft</span> today?
      </h1>
      <p className="mt-3 h-6 max-w-xl font-mono text-sm text-muted">{text}<span className="ml-0.5 inline-block h-4 w-[2px] translate-y-0.5 animate-[blink_1s_steps(1)_infinite] bg-accent" /></p>

      <div className="mt-7 flex flex-wrap items-center justify-center gap-3">
        <button className="btn-gold !px-5 !py-2.5" onClick={() => runDemo()}><Play size={16} /> Run guided demo</button>
        <button className="btn" onClick={onBlank}>Start blank</button>
      </div>

      <div className="mt-8 grid w-full max-w-2xl grid-cols-1 gap-3 sm:grid-cols-3">
        {[
          { i: <FileUp size={18} />, t: "Learn your style", d: "Upload a past draft — tone, structure and clauses are mirrored." },
          { i: <ShieldCheck size={18} />, t: "Verified citations", d: "Every authority is checked. Unsupported ones are flagged, never invented." },
          { i: <Mic size={18} />, t: "Voice-driven", d: "Dictate, edit and confirm risky actions with your voice." },
        ].map((c, k) => (
          <motion.div key={c.t} initial={{ opacity: 0, y: 14 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 + k * 0.1 }} whileHover={{ y: -4 }} className="rounded-2xl border border-line/70 bg-panel/50 p-4 text-left">
            <div className="mb-2 flex h-9 w-9 items-center justify-center rounded-lg bg-accent/10 text-accent">{c.i}</div>
            <div className="text-sm font-semibold">{c.t}</div>
            <p className="mt-1 text-xs leading-snug text-muted">{c.d}</p>
          </motion.div>
        ))}
      </div>

      {skills.length > 0 && (
        <div className="mt-6 flex flex-wrap justify-center gap-2">
          {skills.map((s) => (
            <button key={s.id} className="chip transition hover:border-accent/60 hover:text-accent" onClick={() => patch({ activeSkillId: s.id, commandDraft: s.example ?? "" })}>
              <SkillIcon id={s.id} size={13} /> {s.name}
            </button>
          ))}
          <span className="chip"><Sparkles size={12} /> +{Math.max(0, useStore.getState().skills.length - 4)} more</span>
        </div>
      )}
    </motion.div>
  );
}
DMEOF

cat > frontend/lib/tiptap-citation.ts <<'DMEOF'
import { Mark, mergeAttributes } from "@tiptap/core";

/** Inline mark that keeps citation id + verification status on the text. */
export const CitationMark = Mark.create({
  name: "citation",
  inclusive: false,
  addAttributes() {
    return {
      id: {
        default: null,
        parseHTML: (el) => el.getAttribute("data-cite-id"),
        renderHTML: (a) => (a.id ? { "data-cite-id": a.id as string } : {}),
      },
      status: {
        default: "pending",
        parseHTML: (el) => el.getAttribute("data-status") || "pending",
        renderHTML: (a) => ({ "data-status": a.status as string }),
      },
    };
  },
  parseHTML() { return [{ tag: "span[data-cite-id]" }]; },
  renderHTML({ HTMLAttributes }) { return ["span", mergeAttributes({ class: "cite" }, HTMLAttributes), 0]; },
});
DMEOF

cat > frontend/components/DraftEditor.tsx <<'DMEOF'
"use client";
import Placeholder from "@tiptap/extension-placeholder";
import StarterKit from "@tiptap/starter-kit";
import { EditorContent, useEditor } from "@tiptap/react";
import { motion } from "framer-motion";
import { Bold, Heading1, Heading2, Italic, List, Loader2, Redo2, Undo2 } from "lucide-react";
import { useEffect, useMemo, useRef } from "react";
import { plainText } from "@/lib/html";
import { useStore } from "@/lib/store";
import { CitationMark } from "@/lib/tiptap-citation";

export function DraftEditor() {
  const rev = useStore((s) => s.doc.rev);
  const html = useStore((s) => s.doc.html);
  const streaming = useStore((s) => s.streaming);
  const citations = useStore((s) => s.citations);
  const activeId = useStore((s) => s.activeCitationId);
  const flashKey = useStore((s) => s.flashKey);
  const scroller = useRef<HTMLDivElement>(null);
  const holder = useRef<HTMLDivElement>(null);

  const editor = useEditor({
    immediatelyRender: false,
    extensions: [StarterKit, CitationMark, Placeholder.configure({ placeholder: "Your draft appears here — or just start typing…" })],
    content: useStore.getState().doc.html,
    editorProps: {
      attributes: { class: "legal-doc", spellcheck: "true" },
      handleClick: (_v, _p, e) => {
        const el = (e.target as HTMLElement).closest("[data-cite-id]");
        if (el) useStore.getState().patch({ activeCitationId: el.getAttribute("data-cite-id") });
        return false;
      },
    },
    onUpdate: ({ editor: ed }) => useStore.getState().setUserHtml(ed.getHTML()),
  });

  // External content (stream / edit / delete) → editor
  useEffect(() => {
    if (!editor) return;
    const d = useStore.getState().doc;
    if (d.source === "user") return;
    editor.commands.setContent(d.html, false);
  }, [rev, editor]);

  useEffect(() => { editor?.setEditable(!streaming); }, [streaming, editor]);

  // Citation statuses → marks in the text
  useEffect(() => {
    if (!editor) return;
    const type = editor.schema.marks.citation;
    if (!type) return;
    const map = new Map(citations.map((c) => [c.id, c.status]));
    const tr = editor.state.tr;
    let changed = false;
    editor.state.doc.descendants((node, pos) => {
      if (!node.isText) return;
      node.marks.forEach((m) => {
        if (m.type !== type) return;
        const st = map.get(m.attrs.id);
        if (st && st !== m.attrs.status) {
          tr.removeMark(pos, pos + node.nodeSize, m);
          tr.addMark(pos, pos + node.nodeSize, type.create({ ...m.attrs, status: st }));
          changed = true;
        }
      });
    });
    if (changed) { tr.setMeta("addToHistory", false); editor.view.dispatch(tr); }
  }, [citations, editor, rev]);

  // Active citation → highlight + scroll into view
  useEffect(() => {
    const root = holder.current;
    if (!root) return;
    root.querySelectorAll(".cite-active").forEach((n) => n.classList.remove("cite-active"));
    if (!activeId) return;
    const el = root.querySelector(`[data-cite-id="${activeId}"]`);
    if (el) { el.classList.add("cite-active"); el.scrollIntoView({ behavior: "smooth", block: "center" }); }
  }, [activeId, citations, rev]);

  // Follow the stream
  useEffect(() => {
    if (streaming && scroller.current) scroller.current.scrollTo({ top: scroller.current.scrollHeight });
  }, [rev, streaming]);

  const words = useMemo(() => { const t = plainText(html); return t ? t.split(/\s+/).length : 0; }, [html]);
  const Btn = ({ on, act, children, label }: { on?: boolean; act: () => void; children: React.ReactNode; label: string }) => (
    <button aria-label={label} title={label} onMouseDown={(e) => e.preventDefault()} onClick={act} disabled={streaming} className={`btn-icon !h-8 !w-8 ${on ? "!border-accent/70 !text-accent" : ""}`}>{children}</button>
  );

  return (
    <div className="flex h-full min-h-0 flex-col">
      <div className="mb-2 flex flex-wrap items-center gap-1.5 px-1">
        <Btn label="Bold" on={editor?.isActive("bold")} act={() => editor?.chain().focus().toggleBold().run()}><Bold size={14} /></Btn>
        <Btn label="Italic" on={editor?.isActive("italic")} act={() => editor?.chain().focus().toggleItalic().run()}><Italic size={14} /></Btn>
        <Btn label="Heading 1" on={editor?.isActive("heading", { level: 1 })} act={() => editor?.chain().focus().toggleHeading({ level: 1 }).run()}><Heading1 size={14} /></Btn>
        <Btn label="Heading 2" on={editor?.isActive("heading", { level: 2 })} act={() => editor?.chain().focus().toggleHeading({ level: 2 }).run()}><Heading2 size={14} /></Btn>
        <Btn label="Bullet list" on={editor?.isActive("bulletList")} act={() => editor?.chain().focus().toggleBulletList().run()}><List size={14} /></Btn>
        <span className="mx-1 h-5 w-px bg-line" />
        <Btn label="Undo" act={() => editor?.chain().focus().undo().run()}><Undo2 size={14} /></Btn>
        <Btn label="Redo" act={() => editor?.chain().focus().redo().run()}><Redo2 size={14} /></Btn>
        <div className="ml-auto hidden items-center gap-3 text-[11px] text-muted md:flex">
          {([["verified", "#10b981"], ["partial", "#f59e0b"], ["unverified", "#f43f5e"], ["pending", "#d4a64a"]] as const).map(([l, c]) => (
            <span key={l} className="flex items-center gap-1 capitalize"><i className="h-2 w-2 rounded-full" style={{ background: c }} />{l}</span>
          ))}
          <span>{words} words</span>
        </div>
      </div>

      <div ref={scroller} className="scroll-thin relative min-h-0 flex-1 overflow-y-auto rounded-xl bg-black/5 p-3 dark:bg-black/25">
        <motion.div ref={holder} className={`paper mx-auto max-w-[820px] ${streaming ? "streaming" : ""}`} initial={{ opacity: 0, y: 16, scale: 0.985 }} animate={{ opacity: 1, y: 0, scale: 1 }} transition={{ duration: 0.45 }}>
          {streaming && (
            <div className="absolute inset-x-0 top-0 z-10 h-[3px] overflow-hidden bg-gold-400/20">
              <div className="scanline h-full w-1/3 bg-gradient-to-r from-transparent via-gold-500 to-transparent" />
            </div>
          )}
          <motion.div key={flashKey} initial={flashKey ? { boxShadow: "inset 0 0 0 3px rgba(212,166,74,.65)" } : false} animate={{ boxShadow: "inset 0 0 0 0px rgba(212,166,74,0)" }} transition={{ duration: 1.4 }} className="pointer-events-none absolute inset-0 z-10 rounded-lg" />
          <EditorContent editor={editor} />
        </motion.div>
        {streaming && (
          <div className="pointer-events-none sticky bottom-2 mt-2 flex justify-center">
            <span className="glass flex items-center gap-2 rounded-full px-3 py-1.5 text-xs font-medium"><Loader2 size={13} className="animate-spin text-accent" /> Drafting in your style…</span>
          </div>
        )}
      </div>
    </div>
  );
}
DMEOF

cat > frontend/components/VoiceControl.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { Mic, MicOff } from "lucide-react";
import { useVoice } from "@/lib/voice";

export function VoiceControl() {
  const { supported, state, transcript, toggle } = useVoice();
  const live = state === "listening";
  return (
    <>
      <button onClick={toggle} disabled={!supported} aria-label={live ? "Stop listening" : "Start voice command"} title={supported ? "Voice command" : "Voice needs Chrome / Edge"}
        className={`relative flex h-10 w-10 shrink-0 items-center justify-center rounded-xl border transition ${live ? "mic-live border-rose-500 bg-rose-500/15 text-rose-400" : "border-line/70 bg-panel/60 text-fg/80 hover:border-accent/60 hover:text-accent"} disabled:opacity-40`}>
        {supported ? <Mic size={17} /> : <MicOff size={17} />}
      </button>
      <AnimatePresence>
        {state !== "idle" && (
          <motion.div initial={{ opacity: 0, y: 10, scale: 0.97 }} animate={{ opacity: 1, y: 0, scale: 1 }} exit={{ opacity: 0, y: 10 }} className="glass pointer-events-none absolute -top-14 left-1/2 z-20 flex max-w-[92%] -translate-x-1/2 items-center gap-3 rounded-full px-4 py-2 text-sm">
            <span className={`flex h-5 items-center gap-[3px] ${state === "error" ? "text-amber-400" : "text-rose-400"}`}>
              {[0, 1, 2, 3, 4].map((i) => <i key={i} className="wave-bar" style={{ animationDelay: `${i * 0.12}s`, animationPlayState: live ? "running" : "paused" }} />)}
            </span>
            <span className="truncate">
              <span className="mr-2 text-[10px] font-semibold uppercase tracking-widest text-muted">{state === "listening" ? "Listening" : state === "processing" ? "Understood" : "Error"}</span>
              {transcript || "Speak your instruction…"}
            </span>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
DMEOF

cat > frontend/components/CommandBar.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { ArrowUp, Square, X } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { runInstruction, stopGeneration } from "@/lib/actions";
import { useStore } from "@/lib/store";
import { SkillIcon } from "./SkillIcon";
import { VoiceControl } from "./VoiceControl";

const SUGGEST = ["Verify all citations", "Make paragraph 3 more formal", "Delete paragraph 5", "Dictate: The parties shall resolve disputes by arbitration at Lucknow", "Export as Word"];

export function CommandBar() {
  const [val, setVal] = useState("");
  const [focus, setFocus] = useState(false);
  const ref = useRef<HTMLInputElement>(null);
  const phase = useStore((s) => s.phase);
  const skills = useStore((s) => s.skills);
  const activeId = useStore((s) => s.activeSkillId);
  const draft = useStore((s) => s.commandDraft);
  const patch = useStore((s) => s.patch);
  const busy = phase === "routing" || phase === "drafting" || phase === "editing";
  const skill = skills.find((s) => s.id === activeId);

  useEffect(() => {
    if (draft) { setVal(draft); ref.current?.focus(); patch({ commandDraft: "" }); }
  }, [draft, patch]);

  useEffect(() => {
    const h = (e: KeyboardEvent) => { if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") { e.preventDefault(); ref.current?.focus(); } };
    window.addEventListener("keydown", h);
    return () => window.removeEventListener("keydown", h);
  }, []);

  const submit = () => { const t = val.trim(); if (!t || busy) return; setVal(""); runInstruction(t); };

  return (
    <div className="relative mt-3">
      <div className={`rounded-2xl p-px transition ${focus ? "ring-anim" : "bg-line/70"}`}>
        <div className="flex items-center gap-2 rounded-2xl bg-bg/95 p-2 backdrop-blur">
          <AnimatePresence>
            {skill && (
              <motion.span initial={{ opacity: 0, scale: 0.8, width: 0 }} animate={{ opacity: 1, scale: 1, width: "auto" }} exit={{ opacity: 0, scale: 0.8, width: 0 }} className="chip !border-accent/50 !bg-accent/10 !text-accent whitespace-nowrap">
                <SkillIcon id={skill.id} size={12} /> {skill.name}
                <button aria-label="Clear skill" onClick={() => patch({ activeSkillId: null })}><X size={12} /></button>
              </motion.span>
            )}
          </AnimatePresence>
          <input ref={ref} value={val} onChange={(e) => setVal(e.target.value)} onFocus={() => setFocus(true)} onBlur={() => setFocus(false)} onKeyDown={(e) => e.key === "Enter" && submit()}
            placeholder={skill ? `Instruct ${skill.name}…  e.g. ${skill.example ?? ""}` : "Tell DraftMate what to draft, edit or verify…   (⌘/Ctrl + K)"} className="min-w-0 flex-1 bg-transparent px-2 py-2 text-sm outline-none placeholder:text-muted/70" />
          <VoiceControl />
          {phase === "drafting" ? (
            <button onClick={stopGeneration} aria-label="Stop" className="flex h-10 w-10 items-center justify-center rounded-xl bg-rose-500 text-white"><Square size={15} /></button>
          ) : (
            <button onClick={submit} disabled={!val.trim() || busy} aria-label="Send" className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-gold-300 to-gold-500 text-ink-950 shadow-[0_8px_24px_-8px_rgba(212,166,74,.7)] transition hover:brightness-110 active:scale-95 disabled:opacity-40"><ArrowUp size={18} /></button>
          )}
        </div>
      </div>
      <div className="scroll-thin mt-2 flex gap-1.5 overflow-x-auto pb-1">
        {SUGGEST.map((s) => (
          <button key={s} onClick={() => { setVal(s); ref.current?.focus(); }} className="chip shrink-0 transition hover:border-accent/60 hover:text-accent">{s.length > 44 ? s.slice(0, 42) + "…" : s}</button>
        ))}
      </div>
    </div>
  );
}
DMEOF

cat > frontend/components/layout/CenterPane.tsx <<'DMEOF'
"use client";
import { AnimatePresence } from "framer-motion";
import { useState } from "react";
import { plainText } from "@/lib/html";
import { useStore } from "@/lib/store";
import { CommandBar } from "../CommandBar";
import { DraftEditor } from "../DraftEditor";
import { EmptyState } from "../EmptyState";

export function CenterPane() {
  const has = useStore((s) => plainText(s.doc.html).length > 0);
  const streaming = useStore((s) => s.streaming);
  const [blank, setBlank] = useState(false);
  const showPaper = has || streaming || blank;
  return (
    <section className="glass flex h-full min-h-0 w-full flex-col rounded-2xl p-3.5">
      <div className="min-h-0 flex-1">
        <AnimatePresence mode="wait">
          {showPaper ? <div key="paper" className="h-full"><DraftEditor /></div> : <EmptyState key="empty" onBlank={() => setBlank(true)} />}
        </AnimatePresence>
      </div>
      <CommandBar />
    </section>
  );
}
DMEOF

cat > frontend/components/SummaryRing.tsx <<'DMEOF'
"use client";
import { motion } from "framer-motion";
import type { Citation } from "@/lib/types";

const R = 36;
const C = 2 * Math.PI * R;

export function SummaryRing({ citations }: { citations: Citation[] }) {
  const total = citations.length || 1;
  const n = (s: string) => citations.filter((c) => c.status === s).length;
  const segs = [
    { k: "verified", v: n("verified"), c: "#10b981" },
    { k: "partial", v: n("partial"), c: "#f59e0b" },
    { k: "unverified", v: n("unverified"), c: "#f43f5e" },
    { k: "pending", v: n("pending"), c: "#d4a64a" },
  ];
  let offset = 0;
  const pct = citations.length ? Math.round((n("verified") / citations.length) * 100) : 0;
  return (
    <div className="relative h-24 w-24 shrink-0">
      <svg viewBox="0 0 100 100" className="-rotate-90">
        <circle cx="50" cy="50" r={R} fill="none" stroke="rgb(var(--line))" strokeWidth="9" opacity="0.5" />
        {citations.length > 0 && segs.map((s) => {
          const len = (s.v / total) * C;
          const el = (
            <motion.circle key={s.k} cx="50" cy="50" r={R} fill="none" stroke={s.c} strokeWidth="9" strokeLinecap="butt"
              initial={{ strokeDasharray: `0 ${C}` }} animate={{ strokeDasharray: `${Math.max(len - 1, 0)} ${C}`, strokeDashoffset: -offset }} transition={{ duration: 0.8, ease: "easeOut" }} />
          );
          offset += len;
          return el;
        })}
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="font-display text-xl font-semibold">{citations.length ? `${pct}%` : "—"}</span>
        <span className="text-[9px] uppercase tracking-widest text-muted">verified</span>
      </div>
    </div>
  );
}
DMEOF

cat > frontend/components/CitationCard.tsx <<'DMEOF'
"use client";
import { motion } from "framer-motion";
import { ExternalLink, Lightbulb, Loader2, ShieldAlert, ShieldCheck, ShieldQuestion } from "lucide-react";
import type { Citation } from "@/lib/types";

const META = {
  verified: { label: "Verified", icon: ShieldCheck, cls: "text-emerald-400 border-emerald-500/40 bg-emerald-500/10", bar: "bg-emerald-500" },
  partial: { label: "Partially verified", icon: ShieldQuestion, cls: "text-amber-400 border-amber-500/40 bg-amber-500/10", bar: "bg-amber-500" },
  unverified: { label: "Unverified", icon: ShieldAlert, cls: "text-rose-400 border-rose-500/40 bg-rose-500/10", bar: "bg-rose-500" },
  pending: { label: "Checking sources…", icon: Loader2, cls: "text-accent border-accent/40 bg-accent/10", bar: "bg-accent" },
} as const;

export function CitationCard({ c, active, onSelect }: { c: Citation; active: boolean; onSelect: () => void }) {
  const m = META[c.status];
  const Icon = m.icon;
  const pending = c.status === "pending";
  return (
    <motion.div layout initial={{ opacity: 0, x: 24 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: 24 }} transition={{ type: "spring", stiffness: 380, damping: 32 }}
      onClick={onSelect} role="button" tabIndex={0} onKeyDown={(e) => e.key === "Enter" && onSelect()}
      className={`relative cursor-pointer overflow-hidden rounded-xl border p-3 transition ${active ? "border-sky-400 shadow-[0_0_0_3px_rgba(56,189,248,.25)]" : "border-line/70 hover:border-accent/50"} bg-panel/55`}>
      {pending && <div className="shimmer absolute inset-0 opacity-60" />}
      <div className="relative">
        <div className="mb-1.5 flex items-center justify-between gap-2">
          <span className={`inline-flex items-center gap-1.5 rounded-full border px-2 py-0.5 text-[10.5px] font-semibold ${m.cls}`}>
            <motion.span key={c.status} initial={{ scale: 0.4, rotate: -40 }} animate={{ scale: 1, rotate: 0 }} className="inline-flex"><Icon size={12} className={pending ? "animate-spin" : ""} /></motion.span>
            {m.label}
          </span>
          <span className="chip !py-0.5 capitalize">{c.kind}</span>
        </div>
        <p className="text-[13px] font-medium leading-snug">{c.text}</p>
        {!pending && (
          <>
            <div className="mt-2 flex items-center gap-2">
              <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-line/60">
                <motion.div className={`h-full rounded-full ${m.bar}`} initial={{ width: 0 }} animate={{ width: `${Math.round(c.confidence * 100)}%` }} transition={{ duration: 0.7 }} />
              </div>
              <span className="text-[10.5px] tabular-nums text-muted">{Math.round(c.confidence * 100)}% match</span>
            </div>
            {c.snippet && <p className="mt-2 border-l-2 border-accent/40 pl-2 text-[11.5px] leading-snug text-muted">{c.snippet}</p>}
            {c.note && <p className="mt-2 text-[11.5px] leading-snug text-amber-300/90">⚠ {c.note}</p>}
            {c.suggestion && <p className="mt-1.5 flex gap-1.5 text-[11.5px] leading-snug text-sky-300"><Lightbulb size={12} className="mt-0.5 shrink-0" />{c.suggestion}</p>}
            {c.source_url && (
              <a href={c.source_url} target="_blank" rel="noreferrer" onClick={(e) => e.stopPropagation()} className="mt-2 inline-flex items-center gap-1 text-[11.5px] font-medium text-accent hover:underline">
                <ExternalLink size={12} /> {c.source_name ?? "Source"}
              </a>
            )}
          </>
        )}
      </div>
    </motion.div>
  );
}
DMEOF

cat > frontend/components/TokenMeter.tsx <<'DMEOF'
"use client";
import { animate, motion } from "framer-motion";
import { Zap } from "lucide-react";
import { useEffect, useState } from "react";
import { useStore } from "@/lib/store";

function useCount(v: number) {
  const [n, setN] = useState(0);
  useEffect(() => {
    const c = animate(0, v, { duration: 1.1, ease: "easeOut", onUpdate: (x) => setN(Math.round(x)) });
    return () => c.stop();
  }, [v]);
  return n;
}

export function TokenMeter() {
  const t = useStore((s) => s.tokens);
  const raw = t?.raw ?? 0;
  const sent = t?.sent ?? 0;
  const saved = raw ? Math.round((1 - sent / raw) * 100) : 0;
  const cRaw = useCount(raw), cSent = useCount(sent), cSaved = useCount(saved);
  return (
    <div className="rounded-xl border border-line/70 bg-panel/50 p-3">
      <div className="mb-2 flex items-center justify-between">
        <span className="label flex items-center gap-1.5"><Zap size={12} className="text-accent" /> Context efficiency</span>
        {t && <span className="font-display text-lg font-semibold text-accent">{cSaved}% saved</span>}
      </div>
      {!t ? (
        <p className="text-[11.5px] text-muted">Token savings from Markdown conversion, selective retrieval and prompt compression appear after the first draft.</p>
      ) : (
        <div className="space-y-2 text-[11px]">
          <div>
            <div className="mb-1 flex justify-between text-muted"><span>Raw context</span><span className="tabular-nums">{cRaw.toLocaleString()} tokens</span></div>
            <div className="h-2 overflow-hidden rounded-full bg-line/60"><motion.div className="h-full rounded-full bg-muted/60" initial={{ width: 0 }} animate={{ width: "100%" }} transition={{ duration: 0.8 }} /></div>
          </div>
          <div>
            <div className="mb-1 flex justify-between"><span className="text-accent">Sent to model</span><span className="tabular-nums text-accent">{cSent.toLocaleString()} tokens</span></div>
            <div className="h-2 overflow-hidden rounded-full bg-line/60"><motion.div className="h-full rounded-full bg-gradient-to-r from-gold-400 to-gold-600" initial={{ width: 0 }} animate={{ width: `${(sent / raw) * 100}%` }} transition={{ duration: 1.1, delay: 0.2 }} /></div>
          </div>
          <p className="text-muted">Markdown conversion → section retrieval → compression · citations protected</p>
        </div>
      )}
    </div>
  );
}
DMEOF

cat > frontend/components/ReviewChecklist.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { BadgeCheck, Check } from "lucide-react";
import { useStore } from "@/lib/store";

export function ReviewChecklist() {
  const list = useStore((s) => s.checklist);
  const toggle = useStore((s) => s.toggleCheck);
  const done = list.filter((c) => c.done).length;
  return (
    <div className="rounded-xl border border-line/70 bg-panel/50 p-3">
      <div className="mb-2 flex items-center justify-between">
        <span className="label">Human review</span>
        <span className="text-[11px] tabular-nums text-muted">{done}/{list.length}</span>
      </div>
      <div className="mb-2 h-1.5 overflow-hidden rounded-full bg-line/60"><motion.div className="h-full rounded-full bg-accent" animate={{ width: `${(done / list.length) * 100}%` }} /></div>
      <ul className="space-y-1">
        {list.map((c) => (
          <li key={c.id}>
            <button onClick={() => toggle(c.id)} className="flex w-full items-center gap-2 rounded-lg px-1.5 py-1 text-left text-[12px] hover:bg-accent/10">
              <span className={`flex h-4 w-4 shrink-0 items-center justify-center rounded border transition ${c.done ? "border-accent bg-accent text-ink-950" : "border-line"}`}>
                <AnimatePresence>{c.done && <motion.span initial={{ scale: 0 }} animate={{ scale: 1 }} exit={{ scale: 0 }}><Check size={11} strokeWidth={3} /></motion.span>}</AnimatePresence>
              </span>
              <span className={c.done ? "text-muted line-through" : ""}>{c.label}</span>
            </button>
          </li>
        ))}
      </ul>
      <AnimatePresence>
        {done === list.length && (
          <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} exit={{ opacity: 0, height: 0 }} className="mt-2 flex items-center gap-1.5 overflow-hidden rounded-lg bg-emerald-500/10 px-2 py-1.5 text-[11.5px] font-medium text-emerald-400">
            <BadgeCheck size={14} /> Ready for advocate sign-off
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
DMEOF

cat > frontend/components/VerificationPanel.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { RefreshCw, ShieldCheck } from "lucide-react";
import { useState } from "react";
import { runVerify } from "@/lib/actions";
import { useStore } from "@/lib/store";
import { CitationCard } from "./CitationCard";
import { SummaryRing } from "./SummaryRing";

const TABS = ["all", "verified", "partial", "unverified"] as const;

export function VerificationPanel() {
  const citations = useStore((s) => s.citations);
  const activeId = useStore((s) => s.activeCitationId);
  const phase = useStore((s) => s.phase);
  const patch = useStore((s) => s.patch);
  const [tab, setTab] = useState<(typeof TABS)[number]>("all");
  const n = (s: string) => citations.filter((c) => c.status === s).length;
  const list = citations.filter((c) => tab === "all" || c.status === tab);
  const verifying = phase === "verifying";

  return (
    <div className="flex min-h-0 flex-1 flex-col">
      <div className="mb-3 flex items-center gap-3">
        <SummaryRing citations={citations} />
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-1.5 font-display text-lg font-semibold"><ShieldCheck size={18} className="text-accent" /> Verification</div>
          <div className="mt-1 space-y-0.5 text-[12px]">
            <div className="flex items-center gap-2"><i className="h-2 w-2 rounded-full bg-emerald-500" />{n("verified")} verified</div>
            <div className="flex items-center gap-2"><i className="h-2 w-2 rounded-full bg-amber-500" />{n("partial")} partially verified</div>
            <div className="flex items-center gap-2"><i className="h-2 w-2 rounded-full bg-rose-500" />{n("unverified")} unverified</div>
          </div>
        </div>
        <button className="btn-icon" disabled={!citations.length || verifying} onClick={() => runVerify()} aria-label="Re-verify citations" title="Re-verify">
          <RefreshCw size={15} className={verifying ? "animate-spin" : ""} />
        </button>
      </div>

      <div className="mb-2 flex gap-1 rounded-xl border border-line/70 bg-panel/40 p-1">
        {TABS.map((t) => (
          <button key={t} onClick={() => setTab(t)} className={`relative flex-1 rounded-lg px-2 py-1 text-[11px] font-semibold capitalize transition ${tab === t ? "text-ink-950" : "text-muted hover:text-fg"}`}>
            {tab === t && <motion.span layoutId="vtab" className="absolute inset-0 rounded-lg bg-gradient-to-br from-gold-300 to-gold-500" />}
            <span className="relative">{t}</span>
          </button>
        ))}
      </div>

      <div className="scroll-thin relative min-h-0 flex-1 space-y-2 overflow-y-auto pr-1">
        {verifying && <div className="shimmer sticky top-0 z-10 h-[3px] rounded-full" />}
        <AnimatePresence initial={false}>
          {list.map((c) => (
            <CitationCard key={c.id} c={c} active={activeId === c.id} onSelect={() => patch({ activeCitationId: activeId === c.id ? null : c.id })} />
          ))}
        </AnimatePresence>
        {citations.length === 0 && (
          <div className="flex h-full flex-col items-center justify-center px-4 py-8 text-center">
            <motion.div animate={{ scale: [1, 1.08, 1] }} transition={{ repeat: Infinity, duration: 3 }} className="mb-3 flex h-14 w-14 items-center justify-center rounded-2xl bg-accent/10 text-accent"><ShieldCheck size={28} /></motion.div>
            <p className="text-sm font-semibold">No authorities to verify yet</p>
            <p className="mt-1 text-xs leading-snug text-muted">Every case, section and rule in your draft is checked against accessible legal sources. Unsupported references are flagged, never invented.</p>
          </div>
        )}
        {citations.length > 0 && list.length === 0 && <p className="py-6 text-center text-xs text-muted">Nothing in this filter.</p>}
      </div>
    </div>
  );
}
DMEOF

cat > frontend/components/layout/RightPane.tsx <<'DMEOF'
import { ReviewChecklist } from "../ReviewChecklist";
import { TokenMeter } from "../TokenMeter";
import { VerificationPanel } from "../VerificationPanel";

export function RightPane() {
  return (
    <aside className="glass flex h-full min-h-0 w-full flex-col gap-3 overflow-hidden rounded-2xl p-3.5">
      <VerificationPanel />
      <div className="scroll-thin max-h-[40%] shrink-0 space-y-2 overflow-y-auto">
        <TokenMeter />
        <ReviewChecklist />
        <p className="px-1 text-center text-[10.5px] leading-snug text-muted">AI-assisted draft. Not legal advice — must be reviewed by a qualified advocate.</p>
      </div>
    </aside>
  );
}
DMEOF

cat > frontend/components/ConfirmModal.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, Mic } from "lucide-react";
import { useEffect } from "react";
import { resolveConfirm } from "@/lib/actions";
import { useStore } from "@/lib/store";

export function ConfirmModal() {
  const c = useStore((s) => s.confirm);
  useEffect(() => {
    if (!c) return;
    const h = (e: KeyboardEvent) => { if (e.key === "Escape") resolveConfirm(false); if (e.key === "Enter") resolveConfirm(true); };
    window.addEventListener("keydown", h);
    return () => window.removeEventListener("keydown", h);
  }, [c]);
  return (
    <AnimatePresence>
      {c && (
        <motion.div className="fixed inset-0 z-[80] flex items-center justify-center bg-black/55 p-4 backdrop-blur-sm" initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={() => resolveConfirm(false)}>
          <motion.div role="alertdialog" aria-modal="true" initial={{ opacity: 0, y: 20, scale: 0.94 }} animate={{ opacity: 1, y: 0, scale: 1 }} exit={{ opacity: 0, y: 10, scale: 0.96 }} transition={{ type: "spring", stiffness: 420, damping: 30 }} onClick={(e) => e.stopPropagation()} className="glass w-full max-w-md rounded-2xl p-6">
            <div className={`mb-4 flex h-12 w-12 items-center justify-center rounded-xl ${c.danger ? "bg-rose-500/15 text-rose-400" : "bg-accent/15 text-accent"}`}><AlertTriangle size={24} /></div>
            <h3 className="font-display text-xl font-semibold">{c.title}</h3>
            <p className="mt-1.5 text-sm text-muted">{c.message}</p>
            <p className="mt-3 flex items-center gap-1.5 text-[11.5px] text-muted"><Mic size={12} /> Say “confirm” or “cancel” · or press Enter / Esc</p>
            <div className="mt-5 flex justify-end gap-2">
              <button className="btn" onClick={() => resolveConfirm(false)}>Cancel</button>
              <button onClick={() => resolveConfirm(true)} className={c.danger ? "inline-flex items-center gap-2 rounded-xl bg-rose-500 px-4 py-2 text-sm font-semibold text-white transition hover:brightness-110 active:scale-[.98]" : "btn-gold"}>{c.confirmLabel}</button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
DMEOF

cat > frontend/components/StatusToasts.tsx <<'DMEOF'
"use client";
import { AnimatePresence, motion } from "framer-motion";
import { AlertTriangle, Check, Loader2 } from "lucide-react";
import { useEffect, useState } from "react";
import { useStore } from "@/lib/store";

export function StatusToasts() {
  const activity = useStore((s) => s.activity);
  const [now, setNow] = useState(() => Date.now());
  useEffect(() => { const t = setInterval(() => setNow(Date.now()), 1000); return () => clearInterval(t); }, []);
  const visible = activity.filter((a) => a.state === "running" || now - a.ts < 6000).slice(-3);
  return (
    <div className="pointer-events-none fixed bottom-20 left-1/2 z-[60] flex -translate-x-1/2 flex-col items-center gap-2 lg:bottom-6 lg:left-auto lg:right-6 lg:translate-x-0 lg:items-end">
      <AnimatePresence initial={false}>
        {visible.map((a) => (
          <motion.div key={a.id} layout initial={{ opacity: 0, y: 16, scale: 0.95 }} animate={{ opacity: 1, y: 0, scale: 1 }} exit={{ opacity: 0, x: 40 }} className="glass flex max-w-[88vw] items-center gap-2.5 rounded-full py-2 pl-3 pr-4 text-[12.5px] font-medium">
            {a.state === "running" ? <Loader2 size={14} className="animate-spin text-accent" /> : a.state === "done" ? <Check size={14} className="text-emerald-400" /> : <AlertTriangle size={14} className="text-rose-400" />}
            <span className="truncate">{a.label}</span>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
}
DMEOF

cat > frontend/components/MobileTabs.tsx <<'DMEOF'
"use client";
import { motion } from "framer-motion";
import { FileText, Library, ShieldCheck } from "lucide-react";
import { useStore } from "@/lib/store";

const TABS = [
  { id: "skills", label: "Skills", icon: Library },
  { id: "draft", label: "Draft", icon: FileText },
  { id: "review", label: "Review", icon: ShieldCheck },
] as const;

export function MobileTabs() {
  const tab = useStore((s) => s.mobileTab);
  const patch = useStore((s) => s.patch);
  return (
    <nav className="glass relative z-20 mx-3 mb-3 flex rounded-2xl p-1 lg:hidden">
      {TABS.map((t) => (
        <button key={t.id} onClick={() => patch({ mobileTab: t.id })} className={`relative flex flex-1 items-center justify-center gap-1.5 rounded-xl py-2 text-xs font-semibold ${tab === t.id ? "text-ink-950" : "text-muted"}`}>
          {tab === t.id && <motion.span layoutId="mtab" className="absolute inset-0 rounded-xl bg-gradient-to-br from-gold-300 to-gold-500" />}
          <t.icon size={15} className="relative" /> <span className="relative">{t.label}</span>
        </button>
      ))}
    </nav>
  );
}
DMEOF

cat > frontend/components/Workspace.tsx <<'DMEOF'
"use client";
import { useEffect } from "react";
import { bootstrap } from "@/lib/actions";
import { useStore } from "@/lib/store";
import { AnimatedBackground } from "./AnimatedBackground";
import { ConfirmModal } from "./ConfirmModal";
import { MobileTabs } from "./MobileTabs";
import { Splash } from "./Splash";
import { StatusToasts } from "./StatusToasts";
import { CenterPane } from "./layout/CenterPane";
import { LeftPane } from "./layout/LeftPane";
import { RightPane } from "./layout/RightPane";
import { TopBar } from "./layout/TopBar";

export function Workspace() {
  const tab = useStore((s) => s.mobileTab);
  useEffect(() => { bootstrap(); }, []);
  const show = (id: string) => (tab === id ? "flex" : "hidden") + " lg:flex";
  return (
    <div className="relative flex h-dvh w-full flex-col">
      <AnimatedBackground />
      <Splash />
      <TopBar />
      {/* 3-pane grid:  LEFT = skills + uploads · CENTER = drafting · RIGHT = verification/review */}
      <main className="grid min-h-0 flex-1 gap-3 p-3 lg:grid-cols-[300px_minmax(0,1fr)_370px]">
        <div className={`min-h-0 ${show("skills")}`}><LeftPane /></div>
        <div className={`min-h-0 ${show("draft")}`}><CenterPane /></div>
        <div className={`min-h-0 ${show("review")}`}><RightPane /></div>
      </main>
      <MobileTabs />
      <StatusToasts />
      <ConfirmModal />
    </div>
  );
}
DMEOF

cat > frontend/INTEGRATION.md <<'DMEOF'
# Integration guide (read this, teammates!)

The UI runs fully on built-in demo data. To go live, implement the endpoints below —
**no frontend change needed**. Set `NEXT_PUBLIC_API_MODE=auto` (default) and the UI
switches to live as soon as `GET /api/health` returns 200. Any failing live call
falls back to demo data automatically, so the demo can never break on stage.

| Owner | Endpoint | Request → Response (see `lib/types.ts`) |
|---|---|---|
| All | `GET /api/health` | `200 {"ok":true}` |
| M2 | `GET /api/skills` | `Skill[]` (or `{skills: Skill[]}`) |
| M2 | `POST /api/route` | `{instruction, has_draft}` → `{intent, skill_id?, paragraph?, text?}` |
| M2 | `POST /api/draft` (SSE) | `{instruction, skill_id, model, doc_ids}` → frames `data: {"type":"skill","skill_id":".."}` · `{"type":"token","text":".."}` · `{"type":"usage","raw":18420,"sent":3110}` · `{"type":"done"}` |
| M2 | `POST /api/edit` | `{instruction, html, model, paragraph?}` → `{html, summary}` |
| M3 | `POST /api/verify` | `{citations:[{id,text,kind}]}` → `{citations: Citation[]}` |
| M4 | `POST /api/upload` | multipart `file` → `{id, name, size, tokens, style: StyleProfile}` |
| M4 | `POST /api/export?fmt=docx\|pdf` | `{title, html, citations}` → file blob |

## Rules
1. The model MUST wrap every authority in the draft as `[CITE: Section 138, NI Act, 1881]` — the editor turns these into highlighted, verifiable spans.
2. Stream the draft as **Markdown** (`# Title`, `**bold**`, `- bullets`, numbered paragraphs as plain `1. text` lines separated by blank lines).
3. CORS: allow `http://localhost:3000` and your Vercel domain.
4. Voice: `lib/voice.ts` (Web Speech). Member 4 may extend it; any transcript is sent through `runInstruction()` in `lib/actions.ts`.
5. Destructive intents (`delete`, `overwrite`) automatically trigger the confirm modal — just return the right `intent` from `/api/route`.

## Where things live
- `lib/actions.ts` — all workflows (draft, verify, edit, delete, export, upload)
- `lib/api.ts`     — every network call (live + demo fallback)
- `lib/store.ts`   — global state (zustand)
- `components/`    — presentational UI only
DMEOF

echo "✔ All files written."
if [ -z "$SKIP_INSTALL" ]; then
  echo "▶ Installing dependencies..."
  (cd frontend && npm install)
  echo "✔ Done. Run:  cd frontend && npm run dev   →  http://localhost:3000"
else
  echo "Skipped npm install. Run: cd frontend && npm install && npm run dev"
fi
