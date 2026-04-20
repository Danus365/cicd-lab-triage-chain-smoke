# cicd-lab-triage-chain-smoke

Minimal reproduction lab for the T7-CHAIN path:

```
attacker obtains actions:write GITHUB_TOKEN
  (e.g. via prompt injection in a triage workflow)
      │
      ▼
POST /actions/workflows/smoke-test.yml/dispatches { inputs.ref: <attacker SHA> }
      │
      ▼
smoke-test job checks out attacker ref with contents: write
      │
      ▼
npm ci / npm run build / npm test run attacker-controlled code
```

Only workflow present: `.github/workflows/smoke-test.yml` (verbatim copy from
`pillar-labs/gemini-triage-poc`). No triage workflow — the upstream leak is
out of scope here; we simulate the leaked token directly via PAT.

Not a vulnerability in this repo — it is the *downstream sink* of the chain.


<!-- PWNED via T7-CHAIN: triage → actions:write → dispatch → contents:write at 2026-04-20T18:34:24Z -->
