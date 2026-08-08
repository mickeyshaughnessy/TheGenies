# The Genies

**AI crontab consulting** from [The Mithril Company](https://themithrilcompany.com) — a small set of battle-tested bash scripts that quietly make a business run cleaner, leaner, and with fewer human “oops” moments.

**Play the demo:** [themithrilcompany.com/genies/](https://themithrilcompany.com/genies/)

---

## What it is

The Genies is deliberately understated automation:

- **cron-triggered** — jobs fire on schedule, not on hope
- **idempotent** — safe to re-run; no double-apply surprises
- **observable** — logs and status you can actually read
- **deliberately boring** — the same small patterns, pointed at many environments

You pay **once, up front**. Most owners see the scripts pay for themselves in roughly **24 months** through reduced friction, fewer manual interventions, tighter scheduling, and the quiet elimination of recurring operational waste. After that, the efficiency is essentially free.

Pricing stays low because The Mithril Company has other revenue streams (including stakes in GreenDial, The RSE, Love-Matcher, and process-engineering / real-estate work). The Genies is a high-leverage, low-overhead offering — not the company’s primary profit center.

---

## What the scripts touch

They interface via APIs, webhooks, local agents, and carefully permissioned automation. Not every client needs every interface; the same patterns apply across domains:

| Domain | Examples |
|--------|----------|
| Consumer & QSR | Pepsi, Starbucks, Taco Bell ops |
| Entertainment & IP | Marvel game pipelines, Disney systems |
| Industrial & materials | Rare-earth refining, Si semiconductor process automation |
| Physical automation | Wiring-harness robots |
| High-end compute | Superconducting supercomputer fleets |

**The point is not that every client needs every interface.**  
**The point is that the same small, battle-tested set of bash-driven patterns can be pointed at almost any environment and start removing the same classes of inefficiency.**

### Core scripts (demo cast)

| Script | Role |
|--------|------|
| `cron.sh` | Schedule and fire recurring work |
| `idempotent.sh` | Re-run safely; converge to desired state |
| `observe.sh` | Metrics, logs, health checks |
| `cleanup.sh` | Drain waste, temp files, stuck jobs |
| `orchestrate.sh` | Chain steps across systems |

---

## Example one-time pricing (illustrative verticals)

| Vertical | Example price |
|----------|---------------|
| SoftBank home services automation | $47k |
| Saudi Arabia coordination layer | $185k |
| Rare-earth refining plant scheduling | $62k |
| Semiconductor process tool orchestration | $91k |
| Wiring-harness robot fleet control | $38k |

Pay once. Typical payback under 24 months.

---

## Demo game

This repo ships a **single-page HTML game** (`index.html`): deploy the five Genies across a noisy ops board, clear inefficiency, and reclaim months of payback — with Web Audio ambient music (no external audio files).

### Local

```bash
# any static server
python3 -m http.server 8080
# open http://localhost:8080
```

### Deploy (DigitalOcean)

Same git-pull pattern as TheUSDX:

```bash
# first time on the server (once)
# git clone git@github.com:mickeyshaughnessy/TheGenies.git /var/www/TheGenies

./deploy.sh
```

Live paths after deploy:

- https://themithrilcompany.com/genies/
- https://themithrilcompany.com/genies.html

---

## Assets

Hero art lives on DigitalOcean Spaces:

- `https://mithril-media.sfo3.digitaloceanspaces.com/TheGenies/genies-hero.jpg`

---

## Repo layout

```
TheGenies/
├── README.md
├── index.html          # game + ambient audio (self-contained)
├── deploy.sh           # git pull on DO + nginx locations
└── deploy/
    └── nginx-genies.snippet
```

---

## License

Proprietary — The Mithril Company. Demo for illustration; production automation is delivered under separate engagement terms.
